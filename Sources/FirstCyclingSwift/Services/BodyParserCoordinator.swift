//
//  BodyParserCoordinator.swift
//
//
//  Created by Paul Oggero on 4/5/24.
//

import Foundation
import SwiftSoup


internal struct BodyParserCoordinator: DataParser {
    let htmlParser: HTMLParser
    let titleParser: TitleParser
    let additionalInfoParsers: [String: AdditionalInformationParser]
    
    init(
        htmlParser: HTMLParser = MainHTMLParser(),
        titleParser: TitleParser = MainTitleParser(),
        additionalInfoParsers: [String: AdditionalInformationParser] = ["informations": MainAdditionalInformationParser()]
    ) {
        self.htmlParser = htmlParser
        self.titleParser = titleParser
        self.additionalInfoParsers = additionalInfoParsers
    }
    
    func parse(_ htmlString: String) throws -> Any {
        let htmlElement = try htmlParser.parseHTML(fromString: htmlString)
        let title = try titleParser.parseTitle(fromHTML: htmlElement)
        var additionalInformations = [String: [String: String]]()
        
        for (name, parser) in additionalInfoParsers {
            additionalInformations[name] = try parser.parseAdditionalInformations(fromHTML: htmlElement)
        }
        
        return ParsedInformation(title: title, additionalInformations: additionalInformations)
    }
}
