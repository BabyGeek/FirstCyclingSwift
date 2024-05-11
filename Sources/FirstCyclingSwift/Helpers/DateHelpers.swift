//
//  File.swift
//  
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation

struct DateHelpers {
    static func parseDateRange(_ dateString: String) -> (Date?, Date?)? {
        var workingString = dateString
        
        ["st", "nd", "rd", "th"].forEach { suffix in
            workingString = workingString.replacingOccurrences(of: suffix, with: "")
        }
        
        let parts = workingString.replacingOccurrences(of: " - ", with: " ").split(separator: " ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if parts.count == 4 {
            let startDay = String(parts[0])
            let endDay = String(parts[1])
            let month = String(parts[2])
            let year = String(parts[3])
            
            let startDate = dateFormatter.date(from: "\(startDay) \(month) \(year)")
            let endDate = dateFormatter.date(from: "\(endDay) \(month) \(year)")
            
            return (startDate, endDate)
        } else if parts.count == 3 {
            let startDay = String(parts[0])
            let month = String(parts[1])
            let year = String(parts[2])
            
            let startDate = dateFormatter.date(from: "\(startDay) \(month) \(year)")
            
            return (startDate, nil)
        } else {
            return (nil, nil)
        }
    }
}
