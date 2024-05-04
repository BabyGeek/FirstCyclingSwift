//
//  RaceDetailStatisticByYearTableParserCoodinator.swift
//  
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation

struct RaceDetailStatisticByYearTableParserCoodinator: DataParser {
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
    
    internal func parse(_ htmlString: String) throws -> Any {
        let htmlElement = try htmlParser.parseHTML(fromString: htmlString)
        let tables = try tableParser.parseTables(fromHTML: htmlElement)
        
        var parsedRows = [[String: Any]]()
        var tableHeaders = [String]()
        
        
        var parsedStatisticsData = [ParsedRaceDetailStatisticsTable]()
        
        for table in tables {
            tableHeaders = try headerParser.parseHeaders(fromTable: table)
            
            if !tableHeaders.isEmpty {
                guard let yearString = tableHeaders.first, let year = Int(yearString) else {
                    continue
                }
                
                var leaderboard: [[String: Any]] = []
                
                let rows = try table.select("tbody tr")
                for row in rows {
                    var rowData = try columnParser.parseColumns(fromRow: row, withHeaders: tableHeaders)
                    leaderboard.append(rowData)
                }
                
                let raceData = ParsedRaceDetailStatisticsTable(year: year, leaderboard: leaderboard)
                parsedStatisticsData.append(raceData)
            }
        }
        
        return parsedStatisticsData
    }
}
