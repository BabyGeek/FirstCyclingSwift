//
//  File.swift
//  
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup

struct RaceDetailCountryNameParser: AdditionalInformationParser {
    func parseAdditionalInformations(fromHTML html: Element) throws -> [String: String] {
        if let h2Element = try html.select("h2").first() {
            return ["country_name": try h2Element.text()]
        }
        
        return [:]
    }
}
