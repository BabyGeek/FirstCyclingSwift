//
//  MainHeaderParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

struct MainHeaderParser: HeaderParser {
    func parseHeaders(fromTable table: Element) throws -> [String] {
        var headers = [String]()
        if let headerRows = try table.select("thead tr").first()?.select("th") {
            for th in headerRows {
                let header = try th.text()
                if header.isEmpty { continue }
                headers.append(header.lowercased())
            }
        }
        return headers
    }
}
