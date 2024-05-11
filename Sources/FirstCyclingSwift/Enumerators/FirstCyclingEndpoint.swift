//
//  FirstCyclingEndpoint.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

internal enum FirstCyclingEndpoint {
    case race
    case raceDetails(id: Int)
    case raceEdition(id: Int, year: Int)
    
    var path: String {
        switch self {
            case .race, .raceDetails, .raceEdition:
                return Constants.FirstCyclingLinks.Endpoint.race
        }
    }
    
    internal func getURL(withQueryItems additionalQueryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = Constants.FirstCyclingLinks.schema
        components.host = Constants.FirstCyclingLinks.baseURL
        components.path = path
        
        var mandatoryQueryItems = buildMandatoryQueryItems()
        
        if let additionalQueryItems, !additionalQueryItems.isEmpty {
            mandatoryQueryItems.append(contentsOf: additionalQueryItems)
        }
        
        components.queryItems = mandatoryQueryItems
        
        return components.url
    }
    
    internal func buildMandatoryQueryItems() -> [URLQueryItem] {
        switch self {
            case .raceDetails(let id):
                return [.init(name: "r", value: "\(id)")]
            case .raceEdition(let id, let year):
                return [.init(name: "r", value: "\(id)"), .init(name: "y", value: "\(year)")]
            default:
                return []
        }
    }
}
