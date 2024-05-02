    //
    //  MockDataLoader.swift
    //
    //
    //  Created by Paul Oggero on 29/4/24.
    //

import Foundation
import FirstCyclingSwift

struct MockDataLoader: DataLoader {
    private var mockData: [String: Mocks]
    
    init(mockData: [String: Mocks]) {
        self.mockData = mockData
    }
    
    func fetchContent(from url: URL) async throws -> String {
        guard let mockFile = mockData[url.absoluteString] else {
            throw URLError(.badURL)
        }
        
        
        let fileData = try mockFile.getData()
        
        guard let fileContent = String(data: fileData, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return fileContent
    }
}
