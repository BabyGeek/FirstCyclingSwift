//
//  FirstCyclingConvertError.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal enum FirstCyclingConvertError: Error {
    case serializationError(String)
    case decodingError(DecodingError)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
            case .serializationError(let message):
                return NSLocalizedString("Serialization error: \(message)", comment: "Error message for serialization error.")
            case .decodingError(let decodingError):
                switch decodingError {
                    case .typeMismatch(let type, let context):
                        return NSLocalizedString("Decoding error: Type mismatch. Expected type \(type), found: \(context.debugDescription)", comment: "Error message for type mismatch during decoding.")
                        
                    case .keyNotFound(let key, let context):
                        return NSLocalizedString("Decoding error: Key not found. Missing key: \(key.stringValue). Context: \(context.debugDescription)", comment: "Error message for key not found during decoding.")
                        
                    case .valueNotFound(let type, let context):
                        return NSLocalizedString("Decoding error: Value not found. Expected value for type \(type). Context: \(context.debugDescription)", comment: "Error message for value not found during decoding.")
                        
                    case .dataCorrupted(let context):
                        return NSLocalizedString("Decoding error: Data corrupted. Context: \(context.debugDescription)", comment: "Error message for data corrupted during decoding.")
                        
                    @unknown default:
                        return NSLocalizedString("Decoding error: An unknown decoding error occurred. Context: \(decodingError.localizedDescription)", comment: "Error message for unknown decoding error.")
                }
            case .unknownError(let error):
                return NSLocalizedString("An unknown error occurred: \(error.localizedDescription)", comment: "Error message for unknown error.")
        }
    }
}
