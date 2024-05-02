//
//  FirstCyclingImage.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal struct FirstCyclingImage: Codable {
    let src: String
    let header: String
    let place: FirstCyclingImagePlacement
    
    func toDictionary() -> [String: Any] {
        return [
            "src": src,
            "header": header,
            "place": place.rawValue
        ]
    }
}
