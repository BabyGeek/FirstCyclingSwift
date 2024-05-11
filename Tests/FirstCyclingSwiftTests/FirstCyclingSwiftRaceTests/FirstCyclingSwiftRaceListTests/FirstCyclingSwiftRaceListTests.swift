//
//  FirstCyclingSwiftRaceListTests.swift
//  
//
//  Created by Paul Oggero on 30/4/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceListTests: XCTestCase {
    var raceProvider: FirstCyclingRaceEndpointHandler!
    var mockDataLoader: MockDataLoader!
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader(mockData: [
            "https://firstcycling.com/race.php?": .mockRaceListData,
            "https://firstcycling.com/race.php?t=2&y=2024": .mockRaceListFilterByYearAndTypeData,
        ])
        
        raceProvider = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
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
        
        let expectedFirstRace = FirstCyclingRaceSummary(
            id: 1,
            dateRange: "16.01-21.01",
            name: "Tour Down Under",
            category: "2.UWT",
            flag: "🇦🇺",
            winner: FirstCyclingRider(
                id: 37376,
                name: "S. Williams",
                flag: "🇬🇧"
            )
        )
        
        XCTAssertEqual(raceList.first, expectedFirstRace, "First race should equal the expected race")
    }
    
    func testFetchingRaceListWithParameters() async throws {
        let parameters = FirstCyclingRaceListQueryParameters(
            type: FirstCyclingRaceType.RaceType(name: "UCI", value: 2),
            year: "2024"
        )
        
        let raceList = try await raceProvider.fetchRaceList(withParameters: parameters)
        
        XCTAssertNotNil(raceList, "Race list should not be nil")
        XCTAssertFalse(raceList.isEmpty, "Race list should not be empty")
        
        let expectedFirstRace = FirstCyclingRaceSummary(
            id: 295,
            dateRange: "01.04",
            name: "Giro del Belvedere",
            category: "1.2U",
            flag: "🇮🇹",
            winner: FirstCyclingRider(
                id: 114583,
                name: "G. Glivar",
                flag: "🇸🇮"
            )
        )
        
        XCTAssertEqual(raceList.first, expectedFirstRace, "First race should be equal to the expected first race")
    }
    
    func testEmptyDataError() async {
        let mockDataLoader = MockEmptyDataLoader()
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceList()
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
            "https://firstcycling.com/race.php?": .mockRaceEditionResultData,
        ])
        let handler = FirstCyclingRaceEndpointHandler(urlDataLoader: mockDataLoader)
        
        do {
            _ = try await handler.fetchRaceList()
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch FirstCyclingConvertError.decodingError {
                // Then the expected error is thrown
                // Test passes
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
