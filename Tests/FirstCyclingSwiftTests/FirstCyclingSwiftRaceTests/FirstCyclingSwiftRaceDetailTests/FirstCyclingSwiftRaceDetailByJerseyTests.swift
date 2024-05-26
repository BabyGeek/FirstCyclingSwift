//
//  FirstCyclingSwiftRaceDetailByJerseyTests.swift
//  
//
//  Created by Paul Oggero on 26/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceDetailByJerseyTests: XCTestCase {
    var raceProvider: FirstCyclingRaceEndpointHandler!
    var mockDataLoader: MockDataLoader!
    let raceID = 1234
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=\(raceID)": .mockRaceData,
            "https://firstcycling.com/race.php?r=\(raceID)&k=3": .mockRaceDataForPoints,
            "https://firstcycling.com/race.php?r=\(raceID)&k=4": .mockRaceDataForMountain,
            "https://firstcycling.com/race.php?r=\(raceID)&k=2": .mockRaceDataForYouth,
        ])
        
        
        raceProvider = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
    }
    
    override func tearDown() {
        mockDataLoader = nil
        raceProvider = nil
        super.tearDown()
    }
    
    func getRaceDetail(
        withGeneralClassification generalClassification: FirstCyclingGeneralClassification = .overall
    ) async throws -> FirstCyclingRaceDetail {
        try await raceProvider.fetchRaceDetail(
            withID: raceID,
            withGeneralClassification: generalClassification
        )
    }
    
    func testFetchRaceDetailsWithPointsGCReturnsExpected() async throws {
        let race = try await getRaceDetail(withGeneralClassification: .points)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        let expectedFirstEdition: FirstCyclingRaceEditionSummary = .init(
            year: 2024,
            category: "NE",
            winner: .init(
                id: 37278,
                name: "RIKHUNOV Petr",
                flag: "🇷🇺"
            ),
            second: .init(
                id: 16506,
                name: "LAAS Martin",
                flag: "🇪🇪"
            ),
            third: .init(
                id: 61838,
                name: "NOVIKOV Savva",
                flag: "🇷🇺"
            )
        )
        
        try checkExpectedFirstEdition(race, expectedEdition: expectedFirstEdition)
        
        let expectedLastEdition: FirstCyclingRaceEditionSummary = .init(year: 2018, category: "NE")
        try checkExpectedLastEdition(race, expectedEdition: expectedLastEdition)
    }
    
    func testFetchRaceDetailsWithMountainGCReturnsExpected() async throws {
        let race = try await getRaceDetail(withGeneralClassification: .mountain)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        let expectedFirstEdition: FirstCyclingRaceEditionSummary = .init(
            year: 2024,
            category: "NE",
            winner: .init(
                id: 6527,
                name: "FROLOV Igor",
                flag: "🇷🇺"
            ),
            second: .init(
                id: 37278,
                name: "RIKHUNOV Petr",
                flag: "🇷🇺"
            ),
            third: .init(
                id: 57677,
                name: "IVANOV Timofei",
                flag: "🇷🇺"
            )
        )
        
        try checkExpectedFirstEdition(race, expectedEdition: expectedFirstEdition)
        
        let expectedLastEdition: FirstCyclingRaceEditionSummary = .init(year: 2018, category: "NE")
        try checkExpectedLastEdition(race, expectedEdition: expectedLastEdition)
    }
    
    func testFetchRaceDetailsWithYouthGCReturnsExpected() async throws {
        let race = try await getRaceDetail(withGeneralClassification: .youth)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
                
        let expectedFirstEdition: FirstCyclingRaceEditionSummary = .init(
            year: 2024,
            category: "NE",
            winner: .init(
                id: 172908,
                name: "PHAM Le Xuan Loc",
                flag: "🇻🇳"
            )
        )
        try checkExpectedFirstEdition(race, expectedEdition: expectedFirstEdition)
        
        let expectedLastEdition: FirstCyclingRaceEditionSummary = .init(year: 2018, category: "NE")
        try checkExpectedLastEdition(race, expectedEdition: expectedLastEdition)
    }
    
    func checkRaceAttributes(_ race: FirstCyclingRaceDetail) throws {
        XCTAssertEqual(race.id, raceID, "Race id should be \(raceID)")
        XCTAssertEqual(race.name, "HTV Cup", "Race name should be HTV Cup")
        XCTAssertEqual(race.country.name, "Vietnam", "Race country name should be Vietnam")
        XCTAssertNil(race.country.flag, "Race country flag should be nil")
    }
    
    func checkExpectedFirstEdition(_ race: FirstCyclingRaceDetail, expectedEdition: FirstCyclingRaceEditionSummary) throws {
        XCTAssertEqual(race.editions?.first, expectedEdition, "First race edition should be same as expected")
    }
    
    func checkExpectedLastEdition(_ race: FirstCyclingRaceDetail, expectedEdition: FirstCyclingRaceEditionSummary) throws {
        XCTAssertEqual(race.editions?.last, expectedEdition, "First race edition should be same as expected")
    }
}
