//
//  FirstCyclingDataLoader.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public protocol FirstCyclingDataLoader {
    func fetchContent(from url: URL) async throws -> String
}
