//
//  RaceDetailStatisticByYearColumnParser.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup

internal struct RaceDetailStatisticByYearColumnParser: ColumnParser {
    var flagParserDelegate: FlagParser?
    var imageParserDelegate: ImageParser?
    
    internal func parseColumns(fromRow row: Element, withHeaders headers: [String]) throws -> [String: Any] {
        var rowData = [String: Any]()
        var riderData = [String: Any]()
        
        
        if let columns = try? row.select("td") {
            for (_, column) in columns.enumerated() {
                if let positionString = try? row.select("td").get(0).text(),
                   let position = Int(positionString) {
                    rowData["position"] = position
                }
                
                if let flag = try flagParserDelegate?.parseFlag(fromColumn: column) {
                    riderData["flag"] = flag
                }
                
                if let time = try row.select("td").last()?.text(), time != "" {
                    riderData["time"] = time
                }
                
                if let links = try? column.select("a") {
                    for link in links {
                        guard let href = try? link.attr("href") else { continue }
                        
                        if let rValue = href.components(separatedBy: "r=").last?.components(separatedBy: "&").first,
                           let riderID = Int(rValue) {
                            riderData["id"] = riderID
                            
                            if let lastNameSpan = try? link.select("span").first(),
                               let lastNameStyle = try? lastNameSpan.attr("style"),
                               lastNameStyle.contains("text-transform:uppercase"),
                               let lastName = try? lastNameSpan.text() {
                                
                                let linkText = try link.text()
                                let fullName = linkText.replacingOccurrences(of: lastName, with: "").trimmingCharacters(in: .whitespaces)
                                
                                riderData["name"] = "\(lastName.uppercased()) \(fullName)"
                            }
                        }
                    }
                }
            }
        }
        
        rowData["rider"] = riderData
        
        return rowData
    }
}
