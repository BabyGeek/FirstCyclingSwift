//
//  RaceEditionCategoryParser.swift
//
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation
import SwiftSoup

struct RaceEditionCategoryParser: AdditionalInformationParser {
    func parseAdditionalInformations(fromHTML html: Element) throws -> [String: String] {
        if let h2Element = try html.select("h2").first() {
            if let category = try h2Element.text().components(separatedBy: ",").first {
                return ["name": category]
            }
            
            return [:]
        }
        
        return [:]
    }
}

