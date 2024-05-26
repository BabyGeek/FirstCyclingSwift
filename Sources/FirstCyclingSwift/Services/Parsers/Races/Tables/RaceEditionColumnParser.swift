//
//  RaceEditionColumnParser.swift
//
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation
import SwiftSoup

internal struct RaceEditionColumnParser: ColumnParser {
    var flagParserDelegate: FlagParser?
    
    var imageParserDelegate: ImageParser?
    
    func parseColumns(fromRow row: SwiftSoup.Element, withHeaders headers: [String]) throws -> [String : Any] {
        var rowData = [String: Any]()
        
        if let columns = try? row.select("td") {
            for (index, column) in columns.enumerated() {
                if index >= headers.count { continue }
                let header = headers[index]
                
                guard let value = try? column.text() else { continue }
                
                if header.lowercased() == "pos" {
                    if value.lowercased() == "dnf" {
                        rowData["isDNF"] = true
                    } else if value.lowercased() == "dns" {
                        rowData["isDNS"] = true
                    }
                    
                    rowData["position"] = Int(value) ?? -1
                } else if header.lowercased() == "rider" {
                    if value != "" {
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
                                        
                                        let rider: FirstCyclingRider = .init(id: riderID, name: riderName, flag: try flagParserDelegate?.parseFlag(fromColumn: column))
                                        
                                        if var riderDictionary = rowData["rider"] as? [String: Any] {
                                            riderDictionary.merge(rider.toDictionary(), uniquingKeysWith: { (existing, _) in existing })
                                            rowData["rider"] = riderDictionary
                                        } else {
                                            rowData["rider"] = rider.toDictionary()
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else if header.lowercased() == "team" {
                    if var riderDictionary = rowData["rider"] as? [String: Any] {
                        riderDictionary["team"] = value
                        rowData["rider"] = riderDictionary
                    } else {
                        rowData["rider"] = ["team": value]
                    }
                } else if header.lowercased() == "time" && value != "" {
                    if var riderDictionary = rowData["rider"] as? [String: Any] {
                        riderDictionary["time"] = value
                        rowData["rider"] = riderDictionary
                    } else {
                        rowData["rider"] = ["time": value]
                    }
                } else if header.lowercased() == "points", let intVal = Int(value) {
                    if var riderDictionary = rowData["rider"] as? [String: Any] {
                        riderDictionary["points"] = intVal
                        rowData["rider"] = riderDictionary
                    } else {
                        rowData["rider"] = ["points": intVal]
                    }
                }
            }
        }
        
        return rowData
    }
    
}

