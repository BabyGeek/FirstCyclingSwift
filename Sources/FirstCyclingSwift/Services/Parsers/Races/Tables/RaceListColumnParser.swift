//
//  RaceListColumnParser.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation
import SwiftSoup

internal struct RaceListColumnParser: ColumnParser {
    var flagParserDelegate: FlagParser?
    var imageParserDelegate: ImageParser?
    
    internal func parseColumns(fromRow row: Element, withHeaders headers: [String]) throws -> [String: Any] {
        var rowData = [String: Any]()
        
        if let columns = try? row.select("td") {
            for (index, column) in columns.enumerated() {
                if index >= headers.count { continue }
                let header = headers[index]
                
                guard let value = try? column.text() else { continue }
                
                if headers[index].lowercased() == "race" {
                    rowData[header] = value
                    
                    if let flag = try flagParserDelegate?.parseFlag(fromColumn: column) {
                        rowData["flag"] = flag
                    }
                    
                    if let links = try? column.select("a") {
                        for link in links {
                            guard let href = try? link.attr("href") else { continue }
                            
                            if let rValue = href.components(separatedBy: "r=").last?.components(separatedBy: "&").first,
                               let raceID = Int(rValue) {
                                rowData["id"] = raceID
                            }
                        }
                    }
                } else if headers[index].lowercased() == "winner" {
                    if value != "" {
                        if let links = try? column.select("a") {
                            for link in links {
                                guard let href = try? link.attr("href") else { continue }
                                
                                if let rValue = href.components(separatedBy: "r=").last?.components(separatedBy: "&").first,
                                   let riderID = Int(rValue) {
                                    let rider: FirstCyclingRider = .init(id: riderID, name: value, flag: try flagParserDelegate?.parseFlag(fromColumn: column))
                                    rowData[header] = rider.toDictionary()
                                }
                            }
                        }
                    }
                } else if headers[index].lowercased() == "date" {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM"
                    
                    let dates = value.split(separator: "-")
                    
                    guard let start = dateFormatter.date(from: String(dates[0])) else {
                        rowData["start_date"] = Date.now.ISO8601Format()
                        continue
                    }
                    
                    rowData["start_date"] = start.ISO8601Format()
                    
                    if dates.count == 2 {
                        guard let end = dateFormatter.date(from: String(dates[1])) else {
                            continue
                        }
                        rowData["end_date"] = end.ISO8601Format()
                    }
                } else {
                    if let flag = try flagParserDelegate?.parseFlag(fromColumn: column) {
                        rowData[header] = "\(flag) \(value)"
                    } else {
                        rowData[header] = value
                    }
                }
            }
        }
        
        rowData["name"] = rowData["race"]
        rowData["category"] = rowData["cat"]
        
        rowData.removeValue(forKey: "race")
        rowData.removeValue(forKey: "cat")
        
        return rowData
    }
}
