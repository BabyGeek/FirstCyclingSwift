//
//  FirstCyclingRaceEndpointHandler.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public struct FirstCyclingRaceEndpointHandler: Callable {
    public var parserCoordinator: HTMLParsingCoordinator
    public var urlDataLoader: DataLoader
    
    init(urlDataLoader: DataLoader) {
        self.urlDataLoader = urlDataLoader
    }
    
    public func convertDataResults<T: Codable>(fromData data: Data) throws -> T {
            // Your implementation here
    }
}
