//
//  FirstCyclingDataErrorTests.swift
//  
//
//  Created by Paul Oggero on 2/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingDataErrorTests: XCTestCase {
    func testEmptyDataError() {
        let error = FirstCyclingDataError.emptyData
        
        let errorDescription = error.errorDescription
        
        XCTAssertEqual(errorDescription, NSLocalizedString("No data found. Please try again.", comment: "Error message for empty data."))
    }
    
    func testInvalidResponseError() {
        let error = FirstCyclingDataError.invalidResponse
        
        let errorDescription = error.errorDescription
        
        XCTAssertEqual(errorDescription, NSLocalizedString("Invalid response", comment: "Error message for invalid data response."))
    }
}
