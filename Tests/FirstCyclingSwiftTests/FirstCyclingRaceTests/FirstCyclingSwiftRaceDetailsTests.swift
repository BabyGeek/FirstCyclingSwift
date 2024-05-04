//
//  FirstCyclingSwiftRaceDetailsTests.swift
//  
//
//  Created by Paul Oggero on 30/4/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceDetailsTests: XCTestCase {
    var raceProvider: FirstCyclingRaceEndpointHandler!
    var mockDataLoader: MockDataLoader!
    let raceID = 1234
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=1234": .mockRaceData,
            "https://firstcycling.com/race.php?r=1234&k=X": .mockRaceYearStatisticsData,
            "https://firstcycling.com/race.php?r=1234&k=W": .mockRaceVictoryStatisticsData,
        ])
        
        
        raceProvider = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
    }
    
    override func tearDown() {
        mockDataLoader = nil
        raceProvider = nil
        super.tearDown()
    }
    
    func testFetchRaceDetailsWithEmptyDataThrowsError() async {
        let mockDataLoader = MockEmptyDataLoader()
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            
            _ = try await handler.fetchRaceDetail(withID: raceID)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingDataError.emptyData {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRaceDetailsWithInvalidDataThrowsDecodingError() async {
        let mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=1234": .mockRaceEditionData,
        ])
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceDetail(withID: raceID)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingConvertError.decodingError {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    func testFetchRaceStatsWithEmptyDataThrowsError() async {
        let mockDataLoader = MockEmptyDataLoader()
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            
            _ = try await handler.fetchRaceDetailsStatistics(withID: raceID)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingDataError.emptyData {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRaceStatsWithByVictoriesInvalidDataThrowsDecodingError() async {
        let mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=1234&k=X": .mockRaceYearStatisticsData,
            "https://firstcycling.com/race.php?r=1234&k=W": .mockRaceEditionData,
        ])
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceDetailsStatistics(withID: raceID)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingConvertError.decodingError {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRaceStatsWithByYearInvalidDataThrowsDecodingError() async {
        let mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?r=1234&k=X": .mockRaceYearStatisticsBadData,
            "https://firstcycling.com/race.php?r=1234&k=W": .mockRaceVictoryStatisticsData,
        ])
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceDetailsStatistics(withID: raceID)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingConvertError.decodingError {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRaceDetailsReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail()
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        try checkRaceEditions(race)
    }
    
    
    func testFetchRaceStatsByYearReturnsExpected() async throws {
        let raceStatistics = try await getRaceDetailStatistics(forStatisticType: .byYear)
        
        XCTAssertNil(raceStatistics.byVictories, "Race statistics by victories should be nil")
        try checkStatisticByYear(raceStatistics.byYear)
    }
    
    
    func testFetchRaceStatsByVictoriesReturnsExpected() async throws {
        let raceStatistics = try await getRaceDetailStatistics(forStatisticType: .byVictories)
                
        XCTAssertNil(raceStatistics.byYear, "Race statistics by year should be nil")
                
        try checkStatisticsByVictory(raceStatistics.byVictories)
    }
    
    
    func testFetchRaceStatsWithAllStatsReturnsExpected() async throws {
        let raceStatistics = try await getRaceDetailStatistics(forStatisticType: .all)
                                
        try checkStatisticByYear(raceStatistics.byYear)
        try checkStatisticsByVictory(raceStatistics.byVictories)
    }
    
    func testFetchRaceDetailsWithByYearStatsReturnsExpected() async throws {
        let race = try await getRaceDetail(withStatistic: .byYear)
        
        XCTAssertNil(race.statistics?.byVictories, "Race statistics by victories should be nil")
        
        XCTAssertNotNil(race.statistics, "Race statistics should not be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        try checkRaceEditions(race)
        
        try checkStatisticByYear(race.statistics?.byYear)
    }
    
    func testFetchRaceDetailsWithByVictoriesStatsReturnsExpected() async throws {
        let race = try await getRaceDetail(withStatistic: .byVictories)
        
        XCTAssertNil(race.statistics?.byYear, "Race statistics by year should be nil")
        
        XCTAssertNotNil(race.statistics, "Race statistics should not be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        try checkRaceEditions(race)
        
        try checkStatisticsByVictory(race.statistics?.byVictories)
    }
    
    
    func testFetchRaceDetailsWithAllStatsReturnsExpected() async throws {
        let race = try await getRaceDetail(withStatistic: .all)
                
        XCTAssertNotNil(race.statistics, "Race statistics should not be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        try checkRaceEditions(race)
        
        try checkStatisticByYear(race.statistics?.byYear)
        try checkStatisticsByVictory(race.statistics?.byVictories)
    }
    
    func getRaceDetail(withStatistic statisticType: FirstCyclingRaceDetailStatisticType? = nil) async throws -> FirstCyclingRaceDetail {
        try await raceProvider.fetchRaceDetail(withID: raceID, withStatistics: statisticType)
    }
    
    func getRaceDetailStatistics(forStatisticType statisticType: FirstCyclingRaceDetailStatisticType) async throws -> FirstCyclingRaceDetailStatistic {
        try await raceProvider.fetchRaceDetailsStatistics(withID: raceID, andStatistics: statisticType)
    }
    
    
    func checkRaceEditions(_ race: FirstCyclingRaceDetail) throws {
        let expectedFirstRaceEdition = FirstCyclingRaceEditionSummary(year: 2024, category: "1.12.1")
        XCTAssertEqual(race.editions?.first, expectedFirstRaceEdition, "First race edition should be same as expected")
        
        
        let expectedLastRaceEdition = FirstCyclingRaceEditionSummary(year: 1972, category: "NE", winner: FirstCyclingRider(id: 4116, name: "VIEJO José Luis", flag: "🇪🇸"))
        XCTAssertEqual(race.editions?.last, expectedLastRaceEdition, "Last race edition should be same as expected")
    }
    
    func checkRaceAttributes(_ race: FirstCyclingRaceDetail) throws {
        XCTAssertEqual(race.id, raceID, "Race id should be \(raceID)")
        XCTAssertEqual(race.name, "Memorial Valenciaga", "Race name should be Memorial Valenciaga")
        XCTAssertEqual(race.countryName, "Spain", "Race country name should be Spain")
    }
            
    func checkStatisticByYear(_ statistics: [FirstCyclingRaceStatisticByYear]?) throws {
        XCTAssertNotNil(statistics, "Race statistics should not be nil")
        XCTAssertEqual(statistics?.first?.year, 2023, "First statistics should be in year 2023")
        XCTAssertEqual(statistics?.last?.year, 1972, "Last statistics should be in year 1972")
        
        try checkFirstStatisticsByYear(statistics?.first)
        try checkLastStatisticsByYear(statistics?.last)
    }
    
    func checkFirstStatisticsByYear(_ statistics: FirstCyclingRaceStatisticByYear?) throws {
        let expectedRankings: [FirstCyclingRiderRank] = [
            FirstCyclingRiderRank(
                position: 1,
                rider: FirstCyclingRider(
                    id: 100400,
                    name: "DOMÍNGUEZ David",
                    flag: "🇪🇸",
                    time: "4:06:07"
                )
            ),
            FirstCyclingRiderRank(
                position: 2,
                rider: FirstCyclingRider(
                    id: 116465,
                    name: "MINTEGI Iker",
                    flag: "🇪🇸",
                    time: "+ 02"
                )
            ),
            FirstCyclingRiderRank(
                position: 3,
                rider: FirstCyclingRider(
                    id: 116515,
                    name: "GUTIÉRREZ Jorge",
                    flag: "🇪🇸",
                    time: "+ 14"
                )
            ),
            FirstCyclingRiderRank(
                position: 4,
                rider: FirstCyclingRider(
                    id: 104729,
                    name: "SILVA Thomas",
                    flag: "🇺🇾",
                    time: "+ 1:14"
                )
            ),
            FirstCyclingRiderRank(
                position: 5,
                rider: FirstCyclingRider(
                    id: 69377,
                    name: "AUTRAN Jose",
                    flag: "🇨🇱",
                    time: "+ 1:14"
                )
            ),
            FirstCyclingRiderRank(
                position: 6,
                rider: FirstCyclingRider(
                    id: 95149,
                    name: "TRUEBA Sergio",
                    flag: "🇪🇸",
                    time: "+ 1:14"
                )
            ),
            FirstCyclingRiderRank(
                position: 7,
                rider: FirstCyclingRider(
                    id: 111896,
                    name: "MIRALLES SENDRA Tomas",
                    flag: "🇪🇸",
                    time: "+ 1:14"
                )
            ),
            FirstCyclingRiderRank(
                position: 8,
                rider: FirstCyclingRider(
                    id: 120784,
                    name: "FERNANDEZ Ramon",
                    flag: "🇪🇸",
                    time: "+ 1:14"
                )
            ),
            FirstCyclingRiderRank(
                position: 9,
                rider: FirstCyclingRider(
                    id: 111785,
                    name: "CADENA Edgar",
                    flag: "🇲🇽",
                    time: "+ 1:14"
                )
            ),
            FirstCyclingRiderRank(
                position: 10,
                rider: FirstCyclingRider(
                    id: 155722,
                    name: "ALUSTIZA Nicolas",
                    flag: "🇪🇸",
                    time: "+ 1:14"
                )
            )
        ]
        
        XCTAssertEqual(statistics?.leaderboard, expectedRankings, "First statistics leaderboard should be same as expected")
    }
    
    func checkLastStatisticsByYear(_ statistics: FirstCyclingRaceStatisticByYear?) throws {
        let expectedRankings: [FirstCyclingRiderRank] = [FirstCyclingRiderRank(
            position: 1,
            rider: FirstCyclingRider(
                id: 4116,
                name: "VIEJO José Luis",
                flag: "🇪🇸",
                time: nil
            )
        )]
        
        XCTAssertEqual(statistics?.leaderboard, expectedRankings, "Last statistics leaderboard should be same as expected")
    }
    
    func checkStatisticsByVictory(_ statistics: FirstCyclingRaceStatisticByVictory?) throws {
        XCTAssertNotNil(statistics, "Race statistics should not be nil")
        
        let expectedFirst = FirstCyclingRiderVictoryStatistic(id: 1780, position: 1, name: "MUJIKA Jokin", nation: FirstCyclingNation(name: "Spain", flag: "🇪🇸"), victories: 2, second: 0, third: 0)
        XCTAssertEqual(statistics?.leaderboard.first, expectedFirst, "The first rider in leaderboard should be as expected")
        
        let expectedLast = FirstCyclingRiderVictoryStatistic(id: 5301, position: 4, name: "YANEZ DE LA TORRE Felipe", nation: FirstCyclingNation(name: "Spain", flag: "🇪🇸"), victories: 1, second: 0, third: 0)
        XCTAssertEqual(statistics?.leaderboard.last, expectedLast, "The last rider in leaderboard should be as expected")
    }
}
