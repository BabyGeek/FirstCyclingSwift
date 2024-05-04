//
//  DataParser.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal protocol DataParser {
    func parse(_ htmlString: String) throws -> Any
}
