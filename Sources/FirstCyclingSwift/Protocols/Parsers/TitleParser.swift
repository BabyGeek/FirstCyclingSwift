//
//  TitleParser.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup

protocol TitleParser {
    func parseTitle(fromHTML html: Element) throws -> String
}

