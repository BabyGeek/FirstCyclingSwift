//
//  FirstCyclingSwiftRaceTests.swift
//  
//
//  Created by Paul Oggero on 27/4/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceTests: XCTestCase {
    var raceProvider: FirstCyclingRace!
    var mockDataLoader: MockDataLoader!
    
    override func setUp() {
        super.setUp()

        mockDataLoader = MockDataLoader(fileName: "mockRaceData", fileExtension: "html")
        raceProvider = FirstCyclingRace(urlDataLoader: mockDataLoader)
    }
    
    override func tearDown() {
        mockDataLoader = nil
        raceProvider = nil
        super.tearDown()
    }
    
    func testFetchingRaceList() async throws {
        let raceList = try await raceProvider.fetchRaceList()
        
        XCTAssertNotNil(raceList, "Race list should not be nil")
        XCTAssertFalse(raceList.isEmpty, "Race list should not be empty")
    }
    
    func testFetchingSingleRace() async throws {
        let raceID = "1234"
        
        let race = try await raceProvider.fetchSingleRace(raceID: raceID)
        
        XCTAssertNotNil(race, "Race should not be nil")
        XCTAssertEqual(race.id, raceID, "Race ID should match")
    }
    
    func testFetchingRaceEdition() async throws {
        let raceID = "1234"
        let year = "2023"
        
        let raceEdition = try await raceProvider.fetchRaceEdition(raceID: raceID, year: year)
        
        XCTAssertNotNil(raceEdition, "Race edition should not be nil")
        XCTAssertEqual(raceEdition.raceID, raceID, "Race ID should match")
        
    }
    
    func testFetchingRaceEditionInformations() async throws {
        let raceID = "1234"
        let year = "2023"
        
        let raceEdition = try await raceProvider.fetchRaceEditionInformations(raceID: raceID, year: year)
        
        XCTAssertNotNil(raceEdition, "Race edition should not be nil")
        XCTAssertEqual(raceEdition.raceID, raceID, "Race ID should match")
        
    }
    
    func testFetchingRaceEditionResults() async throws {
        let raceID = "1234"
        let year = "2023"
        
        let raceEdition = try await raceProvider.fetchRaceEditionResults(raceID: raceID, year: year)
        
        XCTAssertNotNil(raceEdition, "Race edition should not be nil")
        XCTAssertEqual(raceEdition.raceID, raceID, "Race ID should match")
        
    }
    
    func testFetchingRaceEditionStarlistNormal() async throws {
        let raceID = "1234"
        let year = "2023"
        
        let starlist = try await raceProvider.fetchRaceEditionStarlist(raceID: raceID, year: year)
        
        XCTAssertNotNil(starlist, "Starlist should not be nil")
    }
    
    func testFetchingRaceEditionStarlistExtended() async throws {
        let raceID = "1234"
        let year = "2023"
        
        let starlist = try await raceProvider.fetchRaceEditionStarlist(raceID: raceID, year: year, type: .extended)
        
        XCTAssertNotNil(starlist, "Starlist should not be nil")
    }
    
    func testFetchingRaceEditionStarlistStatistics() async throws {
        let raceID = "1234"
        let year = "2023"
        
        let starlist = try await raceProvider.fetchRaceEditionStarlist(raceID: raceID, year: year, type: .statistic)
        
        XCTAssertNotNil(starlist, "Starlist should not be nil")
    }
    
    func testFetchingRaceVictoryStatistics() async throws {
        let raceID = "1234"
        
        let stats = try await raceProvider.fetchRaceStatistics(raceID: raceID)
        
        XCTAssertNotNil(stats, "Race statistics should not be nil")
    }
    
    func testFetchingRaceYearByYearStatistics() async throws {
        let raceID = "1234"
        
        let stats = try await raceProvider.fetchRaceStatistics(raceID: raceID, type: .byYear)
        
        XCTAssertNotNil(stats, "Race statistics should not be nil")
    }
    
    func testFetchingRaceYoungestAndOldestStatistics() async throws {
        let raceID = "1234"
        
        let stats = try await raceProvider.fetchRaceStatistics(raceID: raceID, type: .byAge)
        
        XCTAssertNotNil(stats, "Race statistics should not be nil")
    }
    
    func testFetchingRaceWithOptionalEndpoints() async throws {
        let raceID = "1234"
        let includeResults = true
        let includeStatistics = true
        
        let raceData = try await raceProvider.fetchRace(
            raceID: raceID,
            includeResults: includeResults,
            includeStatistics: includeStatistics
        )
        
        XCTAssertNotNil(raceData.results, "Race results should be included")
        XCTAssertNotNil(raceData.statistics, "Race statistics should be included")
    }
    
    func testFetchingRaceEditionWithOptionalEndpoints() async throws {
        let raceID = "1234"
        let year = "2023"
        let includeStarlist = true
        let includeResults = true
        
        let raceEditionData = try await raceProvider.fetchRaceEdition(
            raceID: raceID,
            year: year,
            includeStarlist: includeStarlist,
            includeResults: includeResults
        )
        
        XCTAssertNotNil(raceEditionData.starlist, "Race edition starlist should be included")
        XCTAssertNotNil(raceEditionData.results, "Race edition results should be included")
    }
}
