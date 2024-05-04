//
//  FirstCyclingRaceType.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public enum FirstCyclingRaceType {
    public struct RaceType: Equatable {
        let name: String
        let value: Int
    }
    
    case men(types: [RaceType])
    case women(types: [RaceType])
}

extension FirstCyclingRaceType {
    internal static func raceTypes(for gender: FirstCyclingGender) -> FirstCyclingRaceType {
        switch gender {
            case .men:
                return .men(types: [
                    RaceType(name: "WorldTour", value: 1),
                    RaceType(name: "UCI", value: 2),
                    RaceType(name: "UCI U23", value: 3),
                    RaceType(name: "UCI Junior", value: 4),
                    RaceType(name: "National Championships", value: 8),
                    RaceType(name: "Amateur", value: 10),
                    RaceType(name: "NE Junior", value: 24),
                ])
            case .women:
                return .women(types: [
                    RaceType(name: "WorldTour", value: 5),
                    RaceType(name: "UCI", value: 6),
                    RaceType(name: "Junior", value: 7),
                    RaceType(name: "National Championships", value: 9),
                    RaceType(name: "Amateur", value: 11),
                    RaceType(name: "NE Junior", value: 12)
                ])
        }
    }
}
