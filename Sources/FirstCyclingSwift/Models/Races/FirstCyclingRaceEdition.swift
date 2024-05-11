//
//  FirstCyclingRaceEdition.swift
//
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation

public struct FirstCyclingRaceEdition: Codable, Identifiable, Equatable {
    public let id: Int
    public let year: Int
    public let name: String
    public let category: String
    public let country: FirstCyclingCountry
    public let startDate: Date
    public let endDate: Date?
    public let leaderboard: [FirstCyclingRaceEditionRanking]
}
