//
//  MainColumnParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

struct MainColumnParser: ColumnParser {
    var flagParserDelegate: FlagParser?
    
    var imageParserDelegate: ImageParser?
    
    func parseColumns(fromRow row: Element, withHeaders headers: [String]) throws -> [String: Any] {
        var rowData = [String: Any]()
        
        if let columns = try? row.select("td") {
            for (index, column) in columns.enumerated() {
                if index >= headers.count { continue }
                let header = headers[index]
                
                guard let value = try? column.text() else { continue }
                
                if let flag = try flagParserDelegate?.parseFlag(fromColumn: column) {
                    rowData[header] = "\(flag) \(value)"
                } else {
                    rowData[header] = value
                }
                
                if let image = try imageParserDelegate?.parseImage(fromColumn: column, withHeader: header) {
                    rowData["image"] = image.toDictionary()
                }
            }
        }
        
        return rowData
    }
}
