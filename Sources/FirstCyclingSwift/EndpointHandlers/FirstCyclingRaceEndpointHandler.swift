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
        
        let informationParserCoordinator = BodyParserCoordinator(additionalInfoParser: RaceDetailCountryNameParser())
        let additionalInformations = try informationParserCoordinator.parse(htmlString) as! ParsedInformation
        
        let parserCoordinator = TableParserCoodinator(
            columnParser: RaceDetailColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
        let data = try (parserCoordinator.parse(htmlString) as! ParsedTable).rows
        
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
        
        var editions: [FirstCyclingRaceEditionSummary] = try convertDataResults(
            fromData: try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        )
        
        sortEditions(&editions, by: sortCriterion, order: sortOrder)
        
        var raceDetail: FirstCyclingRaceDetail = .init(
            id: id,
            name: additionalInformations.title,
            countryName: additionalInformations.additionalInformations.first ?? "Not found",
            editions: editions
        )
        
        if let statistics {
            raceDetail.statistics = try await fetchRaceDetailsStatistics(withID: id, andStatistics: statistics)
        }
        
        return raceDetail
    }
    
    public func fetchRaceDetailsStatistics(withID id: Int, andStatistics statistics: FirstCyclingRaceDetailStatisticType = .all) async throws -> FirstCyclingRaceDetailStatistic {
        guard let url = FirstCyclingEndpoint.raceDetails(id: id).getURL() else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.raceDetails(id: id).getURL()))
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
    
    internal func sortEditions(
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
