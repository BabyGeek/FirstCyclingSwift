//
//  FirstCyclingRaceTypeTests.swift
//  
//
//  Created by Paul Oggero on 2/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingRaceTypeTests: XCTestCase {
    func testRaceTypesForMen() {
        let raceType = FirstCyclingRaceType.raceTypes(for: .men)
        
        if case let .men(types) = raceType {
            let expectedTypes = [
                FirstCyclingRaceType.RaceType(name: "WorldTour", value: 1),
                FirstCyclingRaceType.RaceType(name: "UCI", value: 2),
                FirstCyclingRaceType.RaceType(name: "UCI U23", value: 3),
                FirstCyclingRaceType.RaceType(name: "UCI Junior", value: 4),
                FirstCyclingRaceType.RaceType(name: "National Championships", value: 8),
                FirstCyclingRaceType.RaceType(name: "Amateur", value: 10),
                FirstCyclingRaceType.RaceType(name: "NE Junior", value: 24)
            ]
            
            XCTAssertEqual(types, expectedTypes)
        } else {
            XCTFail("Expected FirstCyclingRaceType.men, got different case")
        }
    }
    
    func testRaceTypesForWomen() {
        let raceType = FirstCyclingRaceType.raceTypes(for: .women)
        
        if case let .women(types) = raceType {
            let expectedTypes = [
                FirstCyclingRaceType.RaceType(name: "WorldTour", value: 5),
                FirstCyclingRaceType.RaceType(name: "UCI", value: 6),
                FirstCyclingRaceType.RaceType(name: "Junior", value: 7),
                FirstCyclingRaceType.RaceType(name: "National Championships", value: 9),
                FirstCyclingRaceType.RaceType(name: "Amateur", value: 11),
                FirstCyclingRaceType.RaceType(name: "NE Junior", value: 12)
            ]
            
            XCTAssertEqual(types, expectedTypes)
        } else {
            XCTFail("Expected FirstCyclingRaceType.women, got different case")
        }
    }
}
