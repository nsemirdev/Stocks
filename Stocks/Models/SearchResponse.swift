//
//  SearchResponse.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [Stock]
}

struct Stock: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
