//
//  QueryParameter.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal protocol QueryParameter {
    func toQueryItems() -> [URLQueryItem]
}
