//
//  FirstCyclingRaceEndpointHandler.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public struct FirstCyclingRaceEndpointHandler: Callable {
    internal var parserCoordinator: HTMLParsingCoordinator
    internal var urlDataLoader: FirstCyclingDataLoader
    
    init(urlDataLoader: FirstCyclingDataLoader) {
        self.urlDataLoader = urlDataLoader
        self.parserCoordinator = MainParserCoodinator(
            columnParser: RaceListColumnParser(
                flagParserDelegate: MainFlagParser()
            )
        )
    }
    
    public func fetchRaceList(withParameters parameters: FirstCyclingRaceListQueryParameters? = nil) async throws -> [FirstCyclingRaceSummary] {
        guard let url = FirstCyclingEndpoint.race.getURL(withQueryItems: parameters?.toQueryItems()) else {
            throw FirstCyclingURLError.invalidURL(String(describing: FirstCyclingEndpoint.race.getURL(withQueryItems: parameters?.toQueryItems())))
        }
        
        let htmlString = try await urlDataLoader.fetchContent(from: url)
        let data = try parserCoordinator.parseHTMLDataTable(htmlString).rows
        
        guard !data.isEmpty else { throw FirstCyclingDataError.emptyData }
                
        do {
            return try convertDataResults(fromData: try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted))
        } catch {
            throw error
        }
    }
}
