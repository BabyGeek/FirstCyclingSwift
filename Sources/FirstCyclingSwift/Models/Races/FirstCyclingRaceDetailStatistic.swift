//
//  File.swift
//  
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

public struct FirstCyclingRaceDetailStatistic: Codable, Equatable {
    public let byYear: [FirstCyclingRaceStatisticByYear]?
    public let byVictories: FirstCyclingRaceStatisticByVictory?
}
