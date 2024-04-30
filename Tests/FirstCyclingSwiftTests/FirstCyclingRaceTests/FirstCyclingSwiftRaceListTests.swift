//
//  FirstCyclingSwiftRaceListTests.swift
//  
//
//  Created by Paul Oggero on 30/4/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingSwiftRaceListTests: XCTestCase {
    var raceProvider: FirstCyclingRace!
    var mockDataLoader: MockDataLoader!
    
    override func setUp() {
        super.setUp()
        
        mockDataLoader = MockDataLoader(mockData: [
            URL(string: "https://firstcycling.com/race.php")!: "mockRaceListData",
            URL(string: "https://firstcycling.com/race.php?y=2024&t=2")!: "mockRaceListFilterByYearAndTypeData",
        ])
        
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
        
        let expectedFirstRace = FirstCyclingRace(
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
        let parameters = RaceListQueryParameters(
            type: RaceType(name: "UCI", value: 2),
            year: "2024",
        )
        
        let raceList = try await raceProvider.fetchRaceList(withParameters: parameters)
        
        XCTAssertNotNil(raceList, "Race list should not be nil")
        XCTAssertFalse(raceList.isEmpty, "Race list should not be empty")
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let expectedDateString = "01.04"
        guard let expectedDate = dateFormatter.date(from: expectedDateString) else {
            XCTFail("Failed to create date from expected date string")
            return
        }
        
        
        
        let expectedFirstRace = FirstCyclingRace(
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

}
