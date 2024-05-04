//
//  FirstCyclingURLErrorTests.swift
//  
//
//  Created by Paul Oggero on 2/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingURLErrorTests: XCTestCase {
    func testInvalidURLError() {
            // Given
        let invalidURLString = "http:://invalid-url"
        let error = FirstCyclingURLError.invalidURL(invalidURLString)
        
            // When
        let errorDescription = error.errorDescription
        
            // Then
        XCTAssertEqual(errorDescription, NSLocalizedString("Invalid URL: \(invalidURLString)", comment: "Error message for invalid URL."))
    }
}
