//
//  FirstCyclingSwiftRaceEditionResultsTests.swift
//
//
//  Created by Paul Oggero on 5/4/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceEditionResultsTests: XCTestCase {
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
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&e=4": .mockRaceEditionResultStageData,
        ])
        
        
        raceProvider = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
    }
    
    override func tearDown() {
        mockDataLoader = nil
        raceProvider = nil
        super.tearDown()
    }
    
    func testEmptyDataError() async {
        let mockDataLoader = MockEmptyDataLoader()
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceEdition(withID: raceID, edition: edition)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingDataError.emptyData {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDecodingError() async {
        let mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)": .mockRaceListData,
        ])
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceEdition(withID: raceID, edition: edition)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingConvertError.decodingError {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    func testFetchingRaceEditionResults() async throws {
        let raceEdition = try await raceProvider.fetchRaceEdition(withID: raceID, edition: edition)
        
        XCTAssertFalse(raceEdition.leaderboard, "Race edition leaderboard should not be empty")
        
        let expectedFirstLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 1,
            rider: FirstCyclingRider(
                id: 37278,
                name: "RIKUNOV Petr",
                team: "Tap Doan Loc Troi - An Giang",
                flag: "🇷🇺",
                time: "64:32:08"
            ))
        
        XCTAssertEqual(raceEdition.leaderboard.first, expectedFirstLeaderboardRanking, "First leaderboard rank should equal the expected ranking")
        
        
        let expectedLastLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 1,
            isDNF: true,
            rider: FirstCyclingRider(
                id: 211336,
                name: "PHAM Van Son",
                team: "Thanh Hoa",
                flag: "🇻🇳"
            ))
    }
    
    func checkRaceEditionAttributes(_ raceEdition: FirstCyclingRaceEdition) throws {
        XCTAssertEqual(raceEdition.name, "HTV Cup", "Race name should be HTV Cup")
        XCTAssertEqual(raceEdition.year, 2024, "Race edition should be 2024")
        
        let expectedStartDate = "04/03/2024"
        let expectedEndDate = "04/03/2024"
        
        XCTAssertEqual(raceEdition.startDate, 2024, "Race edition should be 2024")
        XCTAssertEqual(raceEdition.endDate, 2024, "Race edition should be 2024")
    }
}
