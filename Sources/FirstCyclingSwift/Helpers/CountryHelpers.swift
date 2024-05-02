//
//  CountryHelpers.swift
//
//
//  Created by Paul Oggero on 27/4/24.
//

import Foundation

internal struct CountryHelpers {
    static func countryFlagEmoji(for countryCode: String?) -> String? {
        guard let countryCode, countryCode.count == 2 else { return nil }
        
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            flagString.unicodeScalars.append(UnicodeScalar(base + scalar.value)!)
        }
        
        return flagString
    }
}
