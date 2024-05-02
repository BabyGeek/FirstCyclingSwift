//
//  FirstCyclingRider.swift
//  
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

public struct FirstCyclingRider: Identifiable, Codable, Equatable {
    public let id: Int
    public let name: String
    public let flag: String?
    
    internal func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name
        ]
        
        if let flag {
            dict["flag"] = flag
        }
        
        return dict
    }
}
