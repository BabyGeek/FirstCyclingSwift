//
//  MockDataLoader.swift
//
//
//  Created by Paul Oggero on 29/4/24.
//

import Foundation
import FirstCyclingSwift

final class MockDataLoader: DataLoader {
    private var mockData: [URL: String]
    
    init(mockData: [URL: String]) {
        self.mockData = mockData
    }
    
    func fetchContent(from url: URL) async throws -> String {
        guard let fileName = mockData[url] else {
            throw URLError(.badURL)
        }
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "html") else {
            throw URLError(.fileDoesNotExist)
        }
        
        let fileData = try Data(contentsOf: fileURL)
        
        guard let fileContent = String(data: fileData, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return fileContent
    }
}
