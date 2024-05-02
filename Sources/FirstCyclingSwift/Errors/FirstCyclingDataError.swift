//
//  FirstCyclingDataError.swift
//  
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal enum FirstCyclingDataError: Error, LocalizedError {
    case emptyData
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
            case .emptyData:
                return NSLocalizedString("No data found. Please try again.", comment: "Error message for empty data.")
            case .invalidResponse:
                return NSLocalizedString("Invalid response", comment: "Error message for invalid data response.")
        }
    }
}
