//
//  MainImageParser.swift
//
//  Created by Paul Oggero on 30/04/2024.
//

import Foundation
import SwiftSoup

struct MainImageParser: ImageParser {
    func parseImage(fromColumn column: Element, withHeader header: String) throws -> FirstCyclingImage? {
        if let imgTag = try? column.select("img").first(),
           let imgUrl = try? imgTag.attr("src") {
            
            let imgIndex = try column.elementSiblingIndex()
            let valueIndex = try imgTag.elementSiblingIndex()
            
            let place: FirstCyclingImagePlacement
            if imgIndex < valueIndex {
                place = .prefix
            } else {
                place = .suffix
            }
            
            return .init(src: imgUrl, header: header, place: place)
        }
        
        return nil
    }
}
