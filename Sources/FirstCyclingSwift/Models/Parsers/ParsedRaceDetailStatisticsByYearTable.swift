//
//  ParsedRaceDetailStatisticsTable.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

internal struct ParsedRaceDetailStatisticsTable {
    internal let year: Int
    internal let leaderboard: [[String: Any]]
    
    internal func toDictionnary() -> [String: Any] {
        [
            "year": year,
            "leaderboard": leaderboard
        ]
    }
}
