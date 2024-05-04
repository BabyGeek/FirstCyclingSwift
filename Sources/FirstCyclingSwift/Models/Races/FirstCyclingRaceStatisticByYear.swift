//
//  FirstCyclingRaceStatisticByYear.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

public struct FirstCyclingRaceStatisticByYear: Codable, Equatable {
    public let year: Int
    public let leaderboard: [FirstCyclingRiderRank]
}
