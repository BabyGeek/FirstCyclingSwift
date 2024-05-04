//
//  File.swift
//  
//
//  Created by Paul Oggero on 1/5/24.
//

import Foundation

enum Mocks: String {
    case mockRaceListData = "mockRaceListData.html"
    case mockRaceData = "mockRaceData.html"
    case mockRaceVictoryStatisticsData = "mockRaceVictoryStatisticsData.html"
    case mockRaceYearStatisticsData = "mockRaceYearStatisticsData.html"
    case mockRaceYearStatisticsBadData = "mockRaceYearStatisticsBadData.html"
    case mockRaceEditionData = "mockRaceEditionData.html"
    case mockRaceListFilterByYearAndTypeData = "mockRaceListFilterByYearAndTypeData.html"
    
    var url: URL {
        URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Resources/Mocks/\(self.rawValue)")
    }
    
    func getData() throws -> Data {
        try Data(contentsOf: self.url)
    }
}
