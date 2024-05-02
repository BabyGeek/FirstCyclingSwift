//
//  ColumnParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

protocol ColumnParser {
    var flagParserDelegate: FlagParser? { get set }
    var imageParserDelegate: ImageParser? { get set }
    
    func parseColumns(fromRow row: Element, withHeaders headers: [String]) throws -> [String: Any]
}
