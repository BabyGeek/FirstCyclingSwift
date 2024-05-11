//
//  RaceEditionCountryParser.swift
//  
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation
import SwiftSoup

struct RaceEditionCountryParser: AdditionalInformationParser {
    func parseAdditionalInformations(fromHTML html: Element) throws -> [String: String] {
        if let h2Element = try html.select("h2").first() {
            if let countryName = try h2Element.text().components(separatedBy: ",").last {
                return ["name": countryName]
            }
            
            return [:]
        }
        
        return [:]
    }
}
