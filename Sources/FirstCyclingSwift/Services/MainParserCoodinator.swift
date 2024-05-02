//
//  MainParserCoodinator.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

internal struct MainParserCoodinator: HTMLParsingCoordinator {
    let htmlParser: HTMLParser
    let tableParser: TableParser
    let headerParser: HeaderParser
    var columnParser: ColumnParser
    
    init(
        htmlParser: HTMLParser = MainHTMLParser(),
        tableParser: TableParser = MainTableParser(),
        headerParser: HeaderParser = MainHeaderParser(),
        columnParser: ColumnParser = MainColumnParser()
    ) {
        self.htmlParser = htmlParser
        self.tableParser = tableParser
        self.headerParser = headerParser
        self.columnParser = columnParser
    }
    
    internal func parseHTMLDataTable(_ htmlString: String) throws -> ParsedTable {
        let htmlElement = try htmlParser.parseHTML(fromString: htmlString)
        let tables = try tableParser.parseTables(fromHTML: htmlElement)
        
        var parsedRows = [[String: Any]]()
        var tableHeaders = [String]()
        
        for table in tables {
            tableHeaders = try headerParser.parseHeaders(fromTable: table)
            if !tableHeaders.isEmpty {
                let rows = try table.select("tbody tr")
                for row in rows {
                    let rowData = try columnParser.parseColumns(fromRow: row, withHeaders: tableHeaders)
                    parsedRows.append(rowData)
                }
            }
        }
        
        return ParsedTable(headers: tableHeaders, rows: parsedRows)
    }
}
