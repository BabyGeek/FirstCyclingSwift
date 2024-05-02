//
//  MainTableParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

struct MainTableParser: TableParser {
    func parseTables(fromHTML html: Element) throws -> Elements {
        return try html.select("table")
    }
}
