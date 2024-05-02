//
//  ImageParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

protocol ImageParser {
    func parseImage(fromColumn column: Element, withHeader header: String) throws -> FirstCyclingImage?
}
