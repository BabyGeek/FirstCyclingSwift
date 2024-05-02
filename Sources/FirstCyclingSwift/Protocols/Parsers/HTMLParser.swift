//
//  HTMLParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

protocol HTMLParser {
    func parseHTML(fromString htmlString: String) throws -> Element
}
