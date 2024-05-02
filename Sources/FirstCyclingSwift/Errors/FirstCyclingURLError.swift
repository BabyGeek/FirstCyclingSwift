//
//  FirstCyclingURLError.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal enum FirstCyclingURLError: Error, LocalizedError {
    case invalidURL(String)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL(let urlString):
                return NSLocalizedString("Invalid URL: \(urlString)", comment: "Error message for invalid URL.")
        }
    }
}
