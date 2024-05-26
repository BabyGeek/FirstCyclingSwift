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
            "https://firstcycling.com/race.php?r=1234": .mockRaceEditionResultData,
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
    
    func testFetchRaceDetailsReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail()
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        try checkRaceEditions(race)
    }
    
    func testFetchRaceDetailsWithSortEditionASCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortOrder: .ascending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 1972, "First race edition year should be 1972")
        XCTAssertEqual(race.editions?.last?.year, 2024, "Last race edition year should be 2023")
    }
    
    func testFetchRaceDetailsWithSortCategoryASCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .category, sortOrder: .ascending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        try checkRaceEditions(race)
    }
    
    func testFetchRaceDetailsWithSortCategoryDESCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .category, sortOrder: .descending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 2014, "First race edition year should be 2014")
        XCTAssertEqual(race.editions?.last?.year, 2015, "Last race edition year should be 2015")
    }
    
    func testFetchRaceDetailsWithSortWinnerASCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .winnerName, sortOrder: .ascending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 2024, "First race edition year should be 2024")
        XCTAssertEqual(race.editions?.last?.year, 1973, "Last race edition year should be 1973")
    }
    
    func testFetchRaceDetailsWithSortWinnerDESCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .winnerName, sortOrder: .descending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 1973, "First race edition year should be 1973")
        XCTAssertEqual(race.editions?.last?.year, 2024, "Last race edition year should be 2024")
    }
    
    func testFetchRaceDetailsWithSortSecondASCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .secondName, sortOrder: .ascending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 2024, "First race edition year should be 2024")
        XCTAssertEqual(race.editions?.last?.year, 2017, "Last race edition year should be 2017")
    }
    
    func testFetchRaceDetailsWithSortSecondDESCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .secondName, sortOrder: .descending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 2017, "First race edition year should be 2017")
        XCTAssertEqual(race.editions?.last?.year, 1972, "Last race edition year should be 1972")
    }
    
    func testFetchRaceDetailsWithSortThirdASCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .thirdName, sortOrder: .ascending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 2024, "First race edition year should be 2024")
        XCTAssertEqual(race.editions?.last?.year, 2021, "Last race edition year should be 2021")
    }
    
    func testFetchRaceDetailsWithSortThirdDESCReturnsEditionsAndAttributes() async throws {
        let race = try await getRaceDetail(sortCriterion: .thirdName, sortOrder: .descending)
        
        XCTAssertNil(race.statistics, "Race statistics should be nil")
        XCTAssertNotNil(race.editions, "Race editions should not be nil")
        
        try checkRaceAttributes(race)
        
        XCTAssertEqual(race.editions?.first?.year, 2021, "First race edition year should be 2021")
        XCTAssertEqual(race.editions?.last?.year, 1972, "Last race edition year should be 1972")
    }
    
    func getRaceDetail(
        withStatistic statisticType: FirstCyclingRaceDetailStatisticType? = nil,
        sortCriterion: RaceEditionSortCriterion = .year,
        sortOrder: FirstCyclingSwift.SortOrder = .descending
    ) async throws -> FirstCyclingRaceDetail {
        try await raceProvider.fetchRaceDetail(
            withID: raceID,
            withStatistics: statisticType,
            sortCriterion: sortCriterion,
            sortOrder: sortOrder
        )
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
        XCTAssertEqual(race.country.name, "Spain", "Race country name should be Spain")
    }
}
