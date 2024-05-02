//
//  URLDataLoader.swift
//
//
//  Created by Paul Oggero on 30/4/24.
//

import Foundation

struct URLDataLoader: FirstCyclingDataLoader {
    static let shared: URLDataLoader = .init()
    
    func fetchContent(from url: URL) async throws -> String {
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw FirstCyclingDataError.invalidResponse
        }
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw FirstCyclingConvertError.serializationError("Unable to convert data to string")
        }
        
        return htmlString
    }
}
