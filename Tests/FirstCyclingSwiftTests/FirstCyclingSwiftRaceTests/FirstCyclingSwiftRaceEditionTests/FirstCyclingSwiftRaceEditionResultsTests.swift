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
    let raceID = 13858
    let edition = 2024
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)": .mockRaceEditionResultData,
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&l=2": .mockRaceEditionResultDataForYouth,
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&l=3": .mockRaceEditionResultDataForPoints,
            "https://firstcycling.com/race.php?r=\(raceID)&y=\(edition)&l=4": .mockRaceEditionResultDataForMountain,
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
        
        XCTAssertFalse(raceEdition.leaderboard.isEmpty, "Race edition leaderboard should not be empty")
        
        let expectedFirstLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 1,
            rider: FirstCyclingRider(
                id: 37278,
                name: "RIKUNOV Petr",
                team: "Tap Doan Loc Troi - An Giang",
                flag: "🇷🇺",
                time: "64:32:08"
            ))
        
        try checkRaceFirstExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedFirstLeaderboardRanking)
        
        let expectedLastLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: -1,
            isDNF: true,
            rider: FirstCyclingRider(
                id: 211336,
                name: "PHAM Van Son",
                team: "Thanh Hoa",
                flag: "🇻🇳"
            ))
        try checkRaceLastExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedLastLeaderboardRanking)
    }
    
    func testFetchRaceEditionResultYouthJersey() async throws {
        let raceEdition = try await raceProvider.fetchRaceEdition(withID: raceID, edition: edition)
        
        XCTAssertFalse(raceEdition.leaderboard.isEmpty, "Race edition leaderboard should not be empty")
        
        let expectedFirstLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 1,
            rider: FirstCyclingRider(
                id: 172908,
                name: "PHAM Le Xuan Loc",
                team: "Quang Khu 7",
                flag: "🇻🇳",
                time: "64:54:13"
            ))
        
        try checkRaceFirstExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedFirstLeaderboardRanking)
        try checkRaceLastExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedFirstLeaderboardRanking)
    }
    
    func testFetchRaceEditionResultPointsJersey() async throws {
        let raceEdition = try await raceProvider.fetchRaceEdition(withID: raceID, edition: edition)
        
        XCTAssertFalse(raceEdition.leaderboard.isEmpty, "Race edition leaderboard should not be empty")
        
        let expectedFirstLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 1,
            rider: FirstCyclingRider(
                id: 37278,
                name: "RIKUNOV Petr",
                team: "Tap Doan Loc Troi - An Giang",
                flag: "🇷🇺",
                points: 253
            ))
        try checkRaceFirstExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedFirstLeaderboardRanking)
        
        let expectedLastLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 21,
            rider: FirstCyclingRider(
                id: 110353,
                name: "NGUYEN Thang",
                team: "Ho Chi Minh City - Vinama",
                flag: "🇻🇳",
                points: 2
            ))
        try checkRaceLastExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedLastLeaderboardRanking)
    }
    
    func testFetchRaceEditionResultMountainJersey() async throws {
        let raceEdition = try await raceProvider.fetchRaceEdition(withID: raceID, edition: edition)
        
        XCTAssertFalse(raceEdition.leaderboard.isEmpty, "Race edition leaderboard should not be empty")
        
        let expectedFirstLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 1,
            rider: FirstCyclingRider(
                id: 6527,
                name: "FROLOV Igor",
                team: "Ho Chi Minh City - New Group",
                flag: "🇷🇺",
                points: 50
            ))
        try checkRaceFirstExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedFirstLeaderboardRanking)
        
        let expectedLastLeaderboardRanking = FirstCyclingRaceEditionRanking(
            position: 12,
            rider: FirstCyclingRider(
                id: 145610,
                name: "VO Minh Gia Bao",
                team: "Quan Khu 7",
                flag: "🇻🇳",
                points: 6
            ))
        try checkRaceLastExpectedLeaderboard(raceEdition, expedtedLeaderboard: expectedLastLeaderboardRanking)
    }
    
    func checkRaceEditionAttributes(_ raceEdition: FirstCyclingRaceEdition) throws {
        XCTAssertEqual(raceEdition.name, "HTV Cup", "Race name should be HTV Cup")
        XCTAssertEqual(raceEdition.year, 2024, "Race edition should be 2024")
        
        let expectedStartDate = "3 April 2024"
        let expectedEndDate = "30 April 2024"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        XCTAssertEqual(raceEdition.startDate, dateFormatter.date(from: expectedStartDate), "Race edition start date should be 3 April 2024")
        XCTAssertEqual(raceEdition.endDate, dateFormatter.date(from: expectedEndDate), "Race edition end date should be 30 April 2024")
    }
    
    func checkRaceFirstExpectedLeaderboard(_ raceEdition: FirstCyclingRaceEdition, expedtedLeaderboard: FirstCyclingRaceEditionRanking) throws {
        XCTAssertEqual(raceEdition.leaderboard.first, expedtedLeaderboard, "First edition leaderboard should be as expected")
    }
    
    func checkRaceLastExpectedLeaderboard(_ raceEdition: FirstCyclingRaceEdition, expedtedLeaderboard: FirstCyclingRaceEditionRanking) throws {
        XCTAssertEqual(raceEdition.leaderboard.last, expedtedLeaderboard, "Last edition leaderboard should be as expected")
    }
}
