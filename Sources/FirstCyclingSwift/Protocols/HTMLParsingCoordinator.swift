//
//  HTMLParsingCoordinator.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public protocol HTMLParsingCoordinator {
    func parseHTMLDataTable(_ htmlString: String) throws -> ParsedTable
}
