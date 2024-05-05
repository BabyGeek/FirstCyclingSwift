//
//  FirstCyclingSwiftRaceEditionTests.swift
//
//
//  Created by Paul Oggero on 5/4/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceEditionTests: XCTestCase {
    var raceProvider: FirstCyclingRaceEndpointHandler!
    var mockDataLoader: MockDataLoader!
    let raceID = 1234
    let edition = 2024
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)": .mockRaceEditionResultData,
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&l=2": .mockRaceEditionResultYouthData,
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&l=3": .mockRaceEditionResultPointsData,
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&l=4": .mockRaceEditionResultMountainData,
        ])
        
        
        raceProvider = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
    }
    
    override func tearDown() {
        mockDataLoader = nil
        raceProvider = nil
        super.tearDown()
    }
}
