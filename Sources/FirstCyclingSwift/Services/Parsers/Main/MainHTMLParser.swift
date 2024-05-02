//
//  MainHTMLParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

struct MainHTMLParser: HTMLParser {
    func parseHTML(fromString htmlString: String) throws -> Element {
        return try SwiftSoup.parse(htmlString)
    }
}
