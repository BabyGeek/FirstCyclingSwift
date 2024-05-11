//
//  File.swift
//  
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation

public struct FirstCyclingRaceEditionRanking: Codable, Equatable {
    public let position: Int
    public let isDNF: Bool?
    public let isDNS: Bool?
    public let rider: FirstCyclingRider
    
    init(position: Int, isDNF: Bool? = nil, isDNS: Bool? = nil, rider: FirstCyclingRider) {
        self.position = position
        self.isDNF = isDNF
        self.isDNS = isDNS
        self.rider = rider
    }
}
