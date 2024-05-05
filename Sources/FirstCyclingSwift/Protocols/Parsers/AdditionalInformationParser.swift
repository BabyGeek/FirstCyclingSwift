//
//  AdditionalInformationParser.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup

protocol AdditionalInformationParser {
    func parseAdditionalInformations(fromHTML html: Element) throws -> [String: String]
}

