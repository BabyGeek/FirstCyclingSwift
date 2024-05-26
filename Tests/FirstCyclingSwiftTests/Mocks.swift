//
//  File.swift
//  
//
//  Created by Paul Oggero on 1/5/24.
//

import Foundation

enum Mocks: String {
    case mockRaceListData = "mockRaceListData.html"
    case mockRaceListFilterByYearAndTypeData = "mockRaceListFilterByYearAndTypeData.html"
    
    case mockRaceData = "mockRaceData.html"
    case mockRaceDataForPoints = "mockRaceDataForPoints.html"
    case mockRaceDataForMountain = "mockRaceDataForMountain.html"
    case mockRaceDataForYouth = "mockRaceDataForYouth.html"
    
    case mockRaceVictoryStatisticsData = "mockRaceVictoryStatisticsData.html"
    case mockRaceYearStatisticsData = "mockRaceYearStatisticsData.html"
    case mockRaceYearStatisticsBadData = "mockRaceYearStatisticsBadData.html"
    
    case mockRaceEditionResultData = "mockRaceEditionResultData.html"
    case mockRaceEditionResultYouthData = "mockRaceEditionResultYouthData.html"
    case mockRaceEditionResultPointsData = "mockRaceEditionResultPointsData.html"
    case mockRaceEditionResultMountainData = "mockRaceEditionResultMountainData.html"
    
    case mockRaceEditionResultStageData = "mockRaceEditionResultStageData.html"
    
    var url: URL {
        URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Resources/Mocks/\(self.rawValue)")
    }
    
    func getData() throws -> Data {
        try Data(contentsOf: self.url)
    }
}
