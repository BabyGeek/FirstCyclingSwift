//
//  Callable.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal protocol Callable {
    var parserCoordinator: HTMLParsingCoordinator { get }
    var urlDataLoader: FirstCyclingDataLoader { get }
    
    func convertDataResults<T: Codable>(fromData data: Data) throws -> T
}

internal extension Callable {
    func convertDataResults<T: Codable>(fromData data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw FirstCyclingConvertError.decodingError(decodingError)
        } catch {
            throw FirstCyclingConvertError.unknownError(error)
        }
    }
}
