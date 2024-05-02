//
//  FirstCyclingConvertError.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal enum FirstCyclingConvertError: Error {
    case serializationError(String)
    case decodingError(Error)
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
            case .serializationError(let message):
                return NSLocalizedString("Serialization error: \(message)", comment: "Error message for serialization error.")
            case .decodingError(let error):
                return NSLocalizedString("Decoding error: \(error.localizedDescription)", comment: "Error message for decoding error.")
            case .unknownError(let error):
                return NSLocalizedString("An unknown error occurred: \(error.localizedDescription)", comment: "Error message for unknown error.")
        }
    }
}
