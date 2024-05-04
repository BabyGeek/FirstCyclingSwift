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
    let additionalInfoParser: AdditionalInformationParser
    
    init(
        htmlParser: HTMLParser = MainHTMLParser(),
        titleParser: TitleParser = MainTitleParser(),
        additionalInfoParser: AdditionalInformationParser = MainAdditionalInformationParser()
    ) {
        self.htmlParser = htmlParser
        self.titleParser = titleParser
        self.additionalInfoParser = additionalInfoParser
    }
    
    func parse(_ htmlString: String) throws -> Any {
        let htmlElement = try htmlParser.parseHTML(fromString: htmlString)
        let title = try titleParser.parseTitle(fromHTML: htmlElement)
        let additionalInformations = try additionalInfoParser.parseAdditionalInformations(fromHTML: htmlElement)
        
        return ParsedInformation(title: title, additionalInformations: additionalInformations)
    }
}
