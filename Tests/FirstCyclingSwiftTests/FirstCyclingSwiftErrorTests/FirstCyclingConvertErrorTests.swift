//
//  FirstCyclingConvertErrorTests.swift
//  
//
//  Created by Paul Oggero on 2/5/24.
//

import XCTest
@testable import FirstCyclingSwift

final class FirstCyclingConvertErrorTests: XCTestCase {
    func testSerializationError() {
        let errorMessage = "Failed to serialize data"
        let error = FirstCyclingConvertError.serializationError(errorMessage)
        
        let errorDescription = error.errorDescription
        
        XCTAssertEqual(errorDescription, NSLocalizedString("Serialization error: \(errorMessage)", comment: "Error message for serialization error."))
    }
    
    func testTypeMismatchDecodingError() {
        let jsonData = """
        {
            "name": 123
        }
        """.data(using: .utf8)!
        
        struct TestStruct: Codable {
            let name: String
        }
        
        do {
            let _ = try JSONDecoder().decode(TestStruct.self, from: jsonData)
            XCTFail("Expected DecodingError.typeMismatch, but decoding succeeded.")
        } catch let decodingError as DecodingError {
            if case let .typeMismatch(expectedType, context) = decodingError {
                XCTAssertEqual(FirstCyclingConvertError.decodingError(decodingError).errorDescription, NSLocalizedString("Decoding error: Type mismatch. Expected type \(expectedType), found: \(context.debugDescription)", comment: "Error message for type mismatch during decoding."))
            } else {
                XCTFail("Expected DecodingError.typeMismatch, but got a different error type.")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testKeyNotFoundDecodingError() {
        let jsonData = """
        {
            "age": 25
        }
        """.data(using: .utf8)!
        
        struct TestStruct: Codable {
            let name: String
            let age: Int
        }
        
        do {
            let _ = try JSONDecoder().decode(TestStruct.self, from: jsonData)
            XCTFail("Expected DecodingError.keyNotFound, but decoding succeeded.")
        } catch let decodingError as DecodingError {
            if case let .keyNotFound(missingKey, context) = decodingError {
                XCTAssertEqual(FirstCyclingConvertError.decodingError(decodingError).errorDescription, NSLocalizedString("Decoding error: Key not found. Missing key: \(missingKey.stringValue). Context: \(context.debugDescription)", comment: "Error message for key not found during decoding."))
            } else {
                XCTFail("Expected DecodingError.keyNotFound, but got a different error type.")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testValueNotFoundDecodingError() {
        let jsonData = """
        {
            "name": null
        }
        """.data(using: .utf8)!
        
        struct TestStruct: Codable {
            let name: String
        }
        
        do {
            let _ = try JSONDecoder().decode(TestStruct.self, from: jsonData)
            XCTFail("Expected DecodingError.valueNotFound, but decoding succeeded.")
        } catch let decodingError as DecodingError {
            if case let .valueNotFound(expectedType, context) = decodingError {
                XCTAssertEqual(FirstCyclingConvertError.decodingError(decodingError).errorDescription, NSLocalizedString("Decoding error: Value not found. Expected value for type \(expectedType). Context: \(context.debugDescription)", comment: "Error message for value not found during decoding."))
            } else {
                XCTFail("Expected DecodingError.valueNotFound, but got a different error type.")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDataCorruptedDecodingError() {
        let jsonData = "invalid json".data(using: .utf8)!
        
        struct TestStruct: Codable {
            let name: String
        }
        
        do {
            let _ = try JSONDecoder().decode(TestStruct.self, from: jsonData)
            XCTFail("Expected DecodingError.dataCorrupted, but decoding succeeded.")
        } catch let decodingError as DecodingError {
            if case let .dataCorrupted(context) = decodingError {
                XCTAssertEqual(FirstCyclingConvertError.decodingError(decodingError).errorDescription, NSLocalizedString("Decoding error: Data corrupted. Context: \(context.debugDescription)", comment: "Error message for data corrupted during decoding."))
            } else {
                XCTFail("Expected DecodingError.dataCorrupted, but got a different error type.")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testUnknownError() {
        let underlyingError = NSError(domain: "UnknownDomain", code: 2, userInfo: nil)
        let error = FirstCyclingConvertError.unknownError(underlyingError)
        
        let errorDescription = error.errorDescription
        
        XCTAssertEqual(errorDescription, NSLocalizedString("An unknown error occurred: \(underlyingError.localizedDescription)", comment: "Error message for unknown error."))
    }
}
