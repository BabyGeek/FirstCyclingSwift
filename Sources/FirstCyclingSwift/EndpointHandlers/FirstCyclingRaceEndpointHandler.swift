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
}
