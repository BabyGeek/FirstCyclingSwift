//
//  FirstCyclingRace.swift
//  
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public struct FirstCyclingRace: Identifiable, Codable, Equatable {
    public let id: Int
    public let name: String
    public let category: String
    public let startDate: Date
    public let endDate: Date?
    public let flag: String?
    public let winner: FirstCyclingRider?
    
    init?(
        id: Int,
        dateRange: String,
        name: String,
        category: String,
        flag: String?,
        winner: FirstCyclingRider?
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.flag = flag
        self.winner = winner
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        let dates = dateRange.split(separator: "-")
        
        guard let start = dateFormatter.date(from: String(dates[0])) else {
            return nil
        }
        
        self.startDate = start
        
        if dates.count == 2 {
            guard let end = dateFormatter.date(from: String(dates[1])) else {
                return nil
            }
            self.endDate = end
        } else {
            self.endDate = nil
        }
    }
    
    public func displayDates() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        if let endDate {
            return "\(dateFormatter.string(from: startDate))-\(dateFormatter.string(from: endDate))"
        } else {
            return dateFormatter.string(from: startDate)
        }
    }
}
