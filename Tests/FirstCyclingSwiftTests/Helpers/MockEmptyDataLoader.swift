//
//  MockDataFailedLoader.swift
//
//
//  Created by Paul Oggero on 2/5/24.
//

import Foundation
import FirstCyclingSwift

struct MockEmptyDataLoader: FirstCyclingDataLoader {
    func fetchContent(from url: URL) async throws -> String {
        return ""
    }
}
