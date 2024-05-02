//
//  Constants.swift
//
//
//  Created by Paul Oggero on 27/4/24.
//

import Foundation

struct Constants {
    struct FirstCyclingLinks {
        static let baseURL: String = "firstcycling.com"
        static let schema: String = "https"
        
        struct Endpoint {
            static let race: String = "/race.php"
            static let team: String = "/team.php"
            static let ranking: String = "/ranking.php"
        }
    }
}
