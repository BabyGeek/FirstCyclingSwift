//
//  TableParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

protocol TableParser {
    func parseTables(fromHTML html: Element) throws -> Elements
}
