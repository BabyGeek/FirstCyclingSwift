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
    public let editions: [FirstCyclingRaceEditionSummary]?
}
