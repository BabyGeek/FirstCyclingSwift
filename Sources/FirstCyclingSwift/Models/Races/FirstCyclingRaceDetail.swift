//
//  FirstCyclingRaceDetail.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

public struct FirstCyclingRaceDetail: Codable, Equatable {
    public let id: Int
    public let name: String
    public let country: FirstCyclingCountry
    public var statistics: FirstCyclingRaceDetailStatistic?
    public var editions: [FirstCyclingRaceEditionSummary]?
    
    init(id: Int, name: String, country: FirstCyclingCountry, statistics: FirstCyclingRaceDetailStatistic? = nil, editions: [FirstCyclingRaceEditionSummary]? = nil) {
        self.id = id
        self.name = name
        self.country = country
        self.statistics = statistics
        self.editions = editions
    }
}
