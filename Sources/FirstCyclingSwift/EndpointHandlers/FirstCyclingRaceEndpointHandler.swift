//
//  FirstCyclingRaceEndpointHandler.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public struct FirstCyclingRaceEndpointHandler: Callable {
    internal var urlDataLoader: FirstCyclingDataLoader
    
    init(urlDataLoader: FirstCyclingDataLoader) {
        self.urlDataLoader = urlDataLoader
    }
    
    public func fetchRaceList(withParameters parameters: FirstCyclingRaceListQueryParameters? = nil) async throws -> [FirstCyclingRaceSummary] {
        guard let url = FirstCyclingEndpoint.race.getURL(withQueryItems: parameters?.toQueryItems()) else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.race.getURL(withQueryItems: parameters?.toQueryItems())))
        }
        
        let parserCoordinator = TableParserCoodinator(
            columnParser: RaceListColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
        
        let htmlString = try await urlDataLoader.fetchContent(from: url)
        let data = try (parserCoordinator.parse(htmlString) as! ParsedTable).rows
        
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
                
        do {
            return try convertDataResults(fromData: try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted))
        } catch {
            throw error
        }
    }
    
    public func fetchRaceDetail(
        withID id: Int,
        withStatistics statistics: FirstCyclingRaceDetailStatisticType? = nil,
        sortCriterion: RaceEditionSortCriterion = .year,
        sortOrder: SortOrder = .descending
    ) async throws -> FirstCyclingRaceDetail {
        guard let url = FirstCyclingEndpoint.raceDetails(id: id).getURL() else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.raceDetails(id: id).getURL()))
        }
        
        let htmlString = try await urlDataLoader.fetchContent(from: url)
        
        let informationParserCoordinator = BodyParserCoordinator(additionalInfoParsers: ["country": RaceDetailCountryParser()])
        let additionalInformations = try informationParserCoordinator.parse(htmlString) as! ParsedInformation
        
        let parserCoordinator = TableParserCoodinator(
            columnParser: RaceDetailColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
        let data = try (parserCoordinator.parse(htmlString) as! ParsedTable).rows
        
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
        
        do {
            var editions: [FirstCyclingRaceEditionSummary] = try convertDataResults(
                fromData: try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            )
            
            
            sortEditions(&editions, by: sortCriterion, order: sortOrder)
            
            var raceDetail: FirstCyclingRaceDetail = .init(
                id: id,
                name: additionalInformations.title,
                country: .init(
                    name: additionalInformations.additionalInformations["country"]?["name"] ?? "Not found",
                    flag: additionalInformations.additionalInformations["country"]?["flag"]
                ) ,
                editions: editions
            )
            
            if let statistics {
                raceDetail.statistics = try await fetchRaceDetailsStatistics(withID: id, andStatistics: statistics)
            }
            
            return raceDetail
        } catch {
            throw error
        }
    }
    
    public func fetchRaceDetailsStatistics(withID id: Int, andStatistics statisticType: FirstCyclingRaceDetailStatisticType = .all) async throws -> FirstCyclingRaceDetailStatistic {
        var statistics: FirstCyclingRaceDetailStatistic = .init()
        
        switch statisticType {
            case .byYear:
                statistics.byYear = try await fetchRaceDetailsStatisticsByYear(withID: id)
            case .byVictories:
                statistics.byVictories = try await fetchRaceDetailsStatisticsByVictories(withID: id)
            case .all:
                statistics.byYear = try await fetchRaceDetailsStatisticsByYear(withID: id)
                statistics.byVictories = try await fetchRaceDetailsStatisticsByVictories(withID: id)
        }
        
        return statistics
    }
    
    public func fetchRaceEdition(withID id: Int, edition year: Int) async throws -> FirstCyclingRaceEdition {
        guard let url = FirstCyclingEndpoint.raceEdition(id: id, year: year).getURL() else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.raceEdition(id: id, year: year).getURL()))
        }
        print(url.absoluteString)

        
        let htmlString = try await urlDataLoader.fetchContent(from: url)
        
        let informationParserCoordinator = BodyParserCoordinator(additionalInfoParsers: [
            "country": RaceEditionCountryParser(),
            "category": RaceEditionCategoryParser(),
            "dates": RaceEditionDateParser()
        ])
        
        let additionalInformations = try informationParserCoordinator.parse(htmlString) as! ParsedInformation
        
        let parserCoordinator = TableParserCoodinator(
            columnParser: RaceEditionColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
        let data = try (parserCoordinator.parse(htmlString) as! ParsedTable).rows
        
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
        
        do {
            var leaderboard: [FirstCyclingRaceEditionRanking] = try convertDataResults(
                fromData: try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            )
                
            leaderboard.sort { (item1, item2) -> Bool in
                    if item1.position == -1 {
                        return false
                    } else if item2.position == -1 {
                        return true
                    } else {
                        return item1.position < item2.position
                    }
            }
            
            return .init(
                id: id,
                year: year,
                name: additionalInformations.title,
                category: additionalInformations.additionalInformations["category"]?["name"] ?? "Not found",
                country: .init(
                    name: additionalInformations.additionalInformations["country"]?["name"] ?? "Not found",
                    flag: additionalInformations.additionalInformations["country"]?["flag"]
                ),
                startDate: additionalInformations.additionalInformations["dates"]?["start_date"]?.toDate() ?? Date(),
                endDate: additionalInformations.additionalInformations["dates"]?["start_date"]?.toDate(),
                leaderboard: leaderboard
            )
        } catch {
            throw error
        }
    }
    
    fileprivate func fetchRaceDetailsStatisticsByYear(withID id: Int) async throws -> [FirstCyclingRaceStatisticByYear] {
        guard let url = FirstCyclingEndpoint.raceDetails(id: id).getURL(withQueryItems: [.init(name: "k", value: "X")]) else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.raceDetails(id: id).getURL(withQueryItems: [.init(name: "k", value: "X")])))
        }
        
        let parserCoordinator = RaceDetailStatisticByYearTableParserCoodinator(
            columnParser: RaceDetailStatisticByYearColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
        
        let htmlString = try await urlDataLoader.fetchContent(from: url)
        let data = try (parserCoordinator.parse(htmlString) as! [ParsedRaceDetailStatisticsTable])
                
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
        
        do {
            return try convertDataResults(fromData: try JSONSerialization.data(withJSONObject: data.map({ $0.toDictionnary() }), options: .prettyPrinted))
        } catch {
            throw error
        }
    }
    
    
    fileprivate func fetchRaceDetailsStatisticsByVictories(withID id: Int) async throws -> FirstCyclingRaceStatisticByVictory {
        guard let url = FirstCyclingEndpoint.raceDetails(id: id).getURL(withQueryItems: [.init(name: "k", value: "W")]) else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.raceDetails(id: id).getURL(withQueryItems: [.init(name: "k", value: "W")])))
        }
        
        let parserCoordinator = TableParserCoodinator(
            columnParser: RaceDetailStatisticByVictoriesColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
        
        let htmlString = try await urlDataLoader.fetchContent(from: url)
        let data = try (parserCoordinator.parse(htmlString) as! ParsedTable).rows
        
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
        
        do {
            return try convertDataResults(fromData: try JSONSerialization.data(withJSONObject: ["leaderboard": data], options: .prettyPrinted))
        } catch {
            throw error
        }
    }
    
    fileprivate func sortEditions(
        _ editions: inout [FirstCyclingRaceEditionSummary],
        by criterion: RaceEditionSortCriterion,
        order: SortOrder
    ) {
        switch (criterion, order) {
            case (.year, .ascending):
                editions.sort { $0.year < $1.year }
            case (.year, .descending):
                editions.sort { $0.year > $1.year }
            case (.category, .ascending):
                editions.sort { $0.category < $1.category }
            case (.category, .descending):
                editions.sort { $0.category > $1.category }
            case (.winnerName, .ascending):
                editions.sort { ($0.winner?.name ?? "") < ($1.winner?.name ?? "") }
            case (.winnerName, .descending):
                editions.sort { ($0.winner?.name ?? "") > ($1.winner?.name ?? "") }
            case (.secondName, .ascending):
                editions.sort { ($0.second?.name ?? "") < ($1.second?.name ?? "") }
            case (.secondName, .descending):
                editions.sort { ($0.second?.name ?? "") > ($1.second?.name ?? "") }
            case (.thirdName, .ascending):
                editions.sort { ($0.third?.name ?? "") < ($1.third?.name ?? "") }
            case (.thirdName, .descending):
                editions.sort { ($0.third?.name ?? "") > ($1.third?.name ?? "") }
        }
    }
}
