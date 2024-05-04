//
//  FirstCyclingRiderVictoryStatistic.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

public struct FirstCyclingRiderVictoryStatistic: Codable, Equatable {
    public let id: Int
    public let position: Int
    public let name: String
    public let nation: FirstCyclingNation
    public let victories: Int
    public let second: Int
    public let third: Int
}
