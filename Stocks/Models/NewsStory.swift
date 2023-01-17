//
//  NewsStory.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import Foundation

struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let id: Int
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String
}
