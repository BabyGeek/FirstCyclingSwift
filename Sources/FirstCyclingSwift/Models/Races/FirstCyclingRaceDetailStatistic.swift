//
//  File.swift
//  
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

public struct FirstCyclingRaceDetailStatistic: Codable, Equatable {
    public var byYear: [FirstCyclingRaceStatisticByYear]?
    public var byVictories: FirstCyclingRaceStatisticByVictory?
    
    init(byYear: [FirstCyclingRaceStatisticByYear]? = nil, byVictories: FirstCyclingRaceStatisticByVictory? = nil) {
        self.byYear = byYear
        self.byVictories = byVictories
    }
}
