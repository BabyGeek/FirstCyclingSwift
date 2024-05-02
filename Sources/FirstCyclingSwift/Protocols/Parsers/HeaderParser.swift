//
//  HeaderParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

protocol HeaderParser {
    func parseHeaders(fromTable table: Element) throws -> [String]
}
