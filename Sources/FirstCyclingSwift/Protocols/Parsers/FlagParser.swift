//
//  FlagParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

protocol FlagParser {
    func parseFlag(fromColumn column: Element) throws -> String?
}
