//
//  ParsedRaceDetailStatisticsTable.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

internal struct ParsedRaceDetailStatisticsTable {
    internal var year: Int
    internal var leaderboard: [[String: Any]]
    
    init(year: Int = 0, leaderboard: [[String : Any]] = [[:]]) {
        self.year = year
        self.leaderboard = leaderboard
    }
    
    internal func toDictionnary() -> [String: Any] {
        [
            "year": year,
            "leaderboard": leaderboard
        ]
    }
}
