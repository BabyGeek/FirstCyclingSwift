//
//  Callable.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public protocol Callable {
    var parserCoordinator: HTMLParsingCoordinator { get }
    var urlDataLoader: DataLoader { get }
    
    func convertDataResults<T: Codable>(fromData data: Data) throws -> T
}
