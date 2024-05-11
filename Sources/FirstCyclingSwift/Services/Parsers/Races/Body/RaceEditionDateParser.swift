//
//  RaceEditionDateParser.swift
//  
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation
import SwiftSoup

struct RaceEditionDateParser: AdditionalInformationParser {
    func parseAdditionalInformations(fromHTML html: Element) throws -> [String: String] {
        if let h2Element = try html.select("h2").first() {
            let textComponents = try h2Element.text().components(separatedBy: ",")
            
            guard textComponents.count > 2 else { return [:] }
            
            let dateString = textComponents[1]
            
            if let (startDate, endDate) = DateHelpers.parseDateRange(dateString) {
                var resultDict = [String: String]()
                if let startDateFormatted = startDate?.formatted(date: .numeric, time: .omitted) {
                    resultDict["start_date"] = startDateFormatted
                }
                if let endDateFormatted = endDate?.formatted(date: .numeric, time: .omitted) {
                    resultDict["end_date"] = endDateFormatted
                }
                return resultDict
            }
            
            return [:]
        }
        
        return [:]
    }
}
