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
    public let countryName: String
    public var statistics: FirstCyclingRaceDetailStatistic?
    public var editions: [FirstCyclingRaceEditionSummary]?
    
    init(id: Int, name: String, countryName: String, statistics: FirstCyclingRaceDetailStatistic? = nil, editions: [FirstCyclingRaceEditionSummary]? = nil) {
        self.id = id
        self.name = name
        self.countryName = countryName
        self.statistics = statistics
        self.editions = editions
    }
}
