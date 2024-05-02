//
//  MainFlagParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

struct MainFlagParser: FlagParser {
    func parseFlag(fromColumn column: Element) throws -> String? {
        let flagSpan = try column.select("span.flag").first()
        let flagClass = try flagSpan?.className()
        
        return CountryHelpers.countryFlagEmoji(for: flagClass?.components(separatedBy: " ").last?.components(separatedBy: "-").last)
    }
}
