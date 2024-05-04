//
//  FirstCyclingRaceEditionSummary.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

public struct FirstCyclingRaceEditionSummary: Codable, Equatable {
    public let year: Int
    public let category: String
    public let winner: FirstCyclingRider?
    public let second: FirstCyclingRider?
    public let third: FirstCyclingRider?
    
    init(year: Int, category: String, winner: FirstCyclingRider? = nil, second: FirstCyclingRider? = nil, third: FirstCyclingRider? = nil) {
        self.year = year
        self.category = category
        self.winner = winner
        self.second = second
        self.third = third
    }
}
