//
//  ConvertError.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal enum ConvertError: Error {
    case emptyData
    case serializationError(String)
    case decodingError(Error)
    case unknownError(Error)
}
