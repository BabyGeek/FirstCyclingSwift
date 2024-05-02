//
//  HTMLParsingCoordinator.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal protocol HTMLParsingCoordinator {
    func parseHTMLDataTable(_ htmlString: String) throws -> ParsedTable
}
