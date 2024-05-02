//
//  FirstCyclingRaceListQueryParameters.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public struct FirstCyclingRaceListQueryParameters: QueryParameter {
    public var type: FirstCyclingRaceType.RaceType?
    public var year: String?
    public var month: String?
    public var countryAlpha3Code: String?
    
    internal func toQueryItems() -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        if let type {
            queryItems.append(.init(name: "t", value: "\(type.value)"))
        }
        
        if let month {
            queryItems.append(.init(name: "m", value: "\(month)"))
        }
        
        if let year {
            queryItems.append(.init(name: "y", value: "\(year)"))
        }
        
        if let countryAlpha3Code {
            queryItems.append(.init(name: "nat", value: countryAlpha3Code))
        }
        
        return queryItems
    }
}
