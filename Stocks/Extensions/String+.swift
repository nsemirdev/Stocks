//
//  String+.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import Foundation

extension String {
    static func string(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return DateFormatter.prettyDateFormatter.string(from: date)
    }
}
