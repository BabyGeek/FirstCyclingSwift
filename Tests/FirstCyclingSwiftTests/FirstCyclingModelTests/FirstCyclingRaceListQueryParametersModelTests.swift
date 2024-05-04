//
//  FirstCyclingRaceListQueryParametersModelTests.swift
//  
//
//  Created by Paul Oggero on 4/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingRaceListQueryParametersModelTests: XCTestCase {
    func testAllParameters() {
        let type = FirstCyclingRaceType.RaceType(name: "test", value: 1)
        let year = "2024"
        let month = "05"
        let countryCode = "USA"
        
        let parameters = FirstCyclingRaceListQueryParameters(
            type: type,
            year: year,
            month: month,
            countryAlpha3Code: countryCode
        )
        
        let queryItems = parameters.toQueryItems()
        
        XCTAssertEqual(queryItems.count, 4)
        
        XCTAssertEqual(queryItems[0].name, "t")
        XCTAssertEqual(queryItems[0].value, "\(type.value)")
        
        XCTAssertEqual(queryItems[1].name, "m")
        XCTAssertEqual(queryItems[1].value, month)
        
        XCTAssertEqual(queryItems[2].name, "y")
        XCTAssertEqual(queryItems[2].value, year)
        
        XCTAssertEqual(queryItems[3].name, "nat")
        XCTAssertEqual(queryItems[3].value, countryCode)
    }
    
    func testSomeParameters() {
        let type = FirstCyclingRaceType.RaceType(name: "test", value: 2)
        let year = "2024"
        
        let parameters = FirstCyclingRaceListQueryParameters(
            type: type,
            year: year,
            month: nil,
            countryAlpha3Code: nil
        )
        
        let queryItems = parameters.toQueryItems()
        
        XCTAssertEqual(queryItems.count, 2)
        
        XCTAssertEqual(queryItems[0].name, "t")
        XCTAssertEqual(queryItems[0].value, "\(type.value)")
        
        XCTAssertEqual(queryItems[1].name, "y")
        XCTAssertEqual(queryItems[1].value, year)
    }
    
    func testNoParameters() {
        let parameters = FirstCyclingRaceListQueryParameters(
            type: nil,
            year: nil,
            month: nil,
            countryAlpha3Code: nil
        )
        
        let queryItems = parameters.toQueryItems()
        
        XCTAssertEqual(queryItems.count, 0)
    }
}
