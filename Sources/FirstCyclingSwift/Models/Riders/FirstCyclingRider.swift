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
    public let team: String?
    public let flag: String?
    public let time: String?
    
    init(id: Int, name: String, team: String? = nil, flag: String? = nil, time: String? = nil) {
        self.id = id
        self.name = name
        self.team = team
        self.flag = flag
        self.time = time
    }
    
    internal func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name
        ]
        
        if let team {
            dict["team"] = team
        }
        
        if let flag {
            dict["flag"] = flag
        }
        
        if let time {
            dict["time"] = time
        }
        
        return dict
    }
}
