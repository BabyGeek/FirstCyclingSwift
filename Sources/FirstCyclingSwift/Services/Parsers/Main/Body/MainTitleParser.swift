//
//  File.swift
//  
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup

struct MainTitleParser: TitleParser {
    func parseTitle(fromHTML html: Element) throws -> String {
        if let h1Element = try html.select("h1").first() {
            return try h1Element.text()
        }
        
        return "Not found"
    }
}
