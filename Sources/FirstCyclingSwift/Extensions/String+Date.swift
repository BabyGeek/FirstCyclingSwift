//
//  File.swift
//  
//
//  Created by Paul Oggero on 11/5/24.
//

import Foundation

extension String {
    func toDate(_ format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
}
