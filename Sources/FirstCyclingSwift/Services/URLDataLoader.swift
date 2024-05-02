//
//  URLDataLoader.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

struct URLDataLoader: DataLoader {
    static let shared: URLDataLoader = .init()
    
    func fetchContent(from url: URL) async throws -> String {
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to convert data to string"])
        }
        
        return htmlString
    }
}
