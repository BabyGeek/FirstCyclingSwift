//
//  FirstCyclingRaceModelTests.swift
//  
//
//  Created by Paul Oggero on 2/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingRaceModelTests: XCTestCase {
    func testInitInvalidStartDate() {
        let invalidDateRange = "31-12"
        let id = 1
        let name = "Test Race"
        let category = "Test Category"
        let flag: String? = nil
        let winner: FirstCyclingRider? = nil
        
        let race = FirstCyclingRaceSummary(
            id: id,
            dateRange: invalidDateRange,
            name: name,
            category: category,
            flag: flag,
            winner: winner
        )
        
        XCTAssertNil(race, "Initialization should fail due to invalid start date")
    }
    
    func testInitInvalidEndDate() {
        let invalidDateRange = "01.01-31.15"
        let id = 2
        let name = "Test Race"
        let category = "Test Category"
        let flag: String? = nil
        let winner: FirstCyclingRider? = nil
        
        let race = FirstCyclingRaceSummary(
            id: id,
            dateRange: invalidDateRange,
            name: name,
            category: category,
            flag: flag,
            winner: winner
        )
        
        XCTAssertNil(race, "Initialization should fail due to invalid end date")
    }
    
    func testInitInvalidNumberOfDate() {
        let invalidDateRange = "01.01-31-12"
        let id = 2
        let name = "Test Race"
        let category = "Test Category"
        let flag: String? = nil
        let winner: FirstCyclingRider? = nil
        
        let race = FirstCyclingRaceSummary(
            id: id,
            dateRange: invalidDateRange,
            name: name,
            category: category,
            flag: flag,
            winner: winner
        )
        
        XCTAssertNil(race, "Initialization should fail due to invalid end date")
    }

    func testInitValidDateRange() {
        let validDateRange = "01.01-31.12"
        let id = 3
        let name = "Valid Test Race"
        let category = "Valid Test Category"
        let flag: String? = nil
        let winner: FirstCyclingRider? = nil
        
        let race = FirstCyclingRaceSummary(
            id: id,
            dateRange: validDateRange,
            name: name,
            category: category,
            flag: flag,
            winner: winner
        )
        
        XCTAssertNotNil(race, "Initialization should succeed with valid date range")
    }
    
    func testInitValidDateRangeNoEndDate() {
        let validDateRange = "01.01"
        let id = 4
        let name = "Test Race without End Date"
        let category = "Test Category"
        let flag: String? = nil
        let winner: FirstCyclingRider? = nil
        
        let race = FirstCyclingRaceSummary(
            id: id,
            dateRange: validDateRange,
            name: name,
            category: category,
            flag: flag,
            winner: winner
        )
        
        XCTAssertNotNil(race, "Initialization should succeed with valid date range and no end date")
    }
    
    func testDisplayDatesWithStartDateOnly() {
        let validStartDate = "01.01"
        
        let race = FirstCyclingRaceSummary(
            id: 5,
            dateRange: validStartDate,
            name: "Test Race",
            category: "Test Category",
            flag: nil,
            winner: nil
        )
        
        XCTAssertNotNil(race, "Race should be initialized with start date only")
        
        let expectedDisplayDate = validStartDate
        
        XCTAssertEqual(race?.displayDates(), expectedDisplayDate, "displayDates() should return the formatted start date")
    }
    
    func testDisplayDatesWithStartAndEndDate() {
        let validDateRange = "01.01-31.12"
        
        let race = FirstCyclingRaceSummary(
            id: 6,
            dateRange: validDateRange,
            name: "Test Race",
            category: "Test Category",
            flag: nil,
            winner: nil
        )
        
        XCTAssertNotNil(race, "Race should be initialized with start and end date")
        
        let expectedDisplayDate = validDateRange
        
        XCTAssertEqual(race?.displayDates(), expectedDisplayDate, "displayDates() should return the formatted date range")
    }
}
