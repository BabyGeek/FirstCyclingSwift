//
//  FirstCyclingEndpoint.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

enum FirstCyclingEndpoint {
    case race
    case raceDetails(id: Int)
    case raceEdition(id: Int, year: Int)
    
    var path: String {
        switch self {
            case .race, .raceDetails, .raceEdition:
                return Constants.FirstCyclingLinks.Endpoint.race
            default:
                return ""
        }
    }
    
    func getURL(withQueryItems additionalQueryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.FirstCyclingLinks.schema
        components.host = Constants.FirstCyclingLinks.baseURL
        components.path = path
        
        var mandatoryQueryItems = buildMandatoryQueryItems()
        
        if let additionalQueryItems {
            mandatoryQueryItems.append(contentsOf: additionalQueryItems)
        }
        
        components.queryItems = mandatoryQueryItems
        
        return components.url
    }
    
    func buildMandatoryQueryItems() -> [URLQueryItem] {
        switch self {
            case .raceDetails(let id):
                return [.init(name: "r", value: id.formatted())]
            case .raceEdition(let id, let year):
                return [.init(name: "r", value: id.formatted()), .init(name: "y", value: year.formatted())]
            default:
                return []
        }
    }
}
