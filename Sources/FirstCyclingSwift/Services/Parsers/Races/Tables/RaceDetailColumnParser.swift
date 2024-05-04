//
//  RaceDetailColumnParser.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup

internal struct RaceDetailColumnParser: ColumnParser {
    var flagParserDelegate: FlagParser?
    var imageParserDelegate: ImageParser?
    
    internal func parseColumns(fromRow row: Element, withHeaders headers: [String]) throws -> [String: Any] {
        var rowData = [String: Any]()
        
        if let columns = try? row.select("td") {
            for (index, column) in columns.enumerated() {
                if index >= headers.count { continue }
                let header = headers[index]
                
                guard let value = try? column.text() else { continue }
                
                if headers[index].lowercased() == "links" { continue }
                
                if ["winner", "second", "third"].contains(headers[index].lowercased()) {
                    if value != "" && value != "-" {
                        if let links = try? column.select("a") {
                            for link in links {
                                guard let href = try? link.attr("href") else { continue }
                                
                                if let rValue = href.components(separatedBy: "r=").last?.components(separatedBy: "&").first,
                                   let riderID = Int(rValue) {
                                    if let lastNameSpan = try? link.select("span").first(),
                                       let lastNameStyle = try? lastNameSpan.attr("style"),
                                       lastNameStyle.contains("text-transform:uppercase"),
                                       let lastName = try? lastNameSpan.text() {
                                        
                                        let linkText = try link.text()
                                        let fullName = linkText.replacingOccurrences(of: lastName, with: "").trimmingCharacters(in: .whitespaces)
                                        
                                        let riderName = "\(lastName.uppercased()) \(fullName)"
                                        
                                        let flag = try flagParserDelegate?.parseFlag(fromColumn: column)
                                        
                                        let rider = FirstCyclingRider(id: riderID, name: riderName, flag: flag)
                                        
                                        rowData[header] = rider.toDictionary()
                                    }
                                }
                            }
                        }
                    }
                } else if headers[index].lowercased() == "year" {
                    rowData["year"] = Int(value) ?? Calendar.current.component(.year, from: Date())
                } else if headers[index].lowercased() == "cat" {
                    rowData["category"] = value
                }
            }
        }
                
        return rowData
    }
}
