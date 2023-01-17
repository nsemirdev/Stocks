//
//  APICaller.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    private struct Constants {
        static let apiKey = "cf30giaad3i7csbbsc9gcf30giaad3i7csbbsca0"
        static let sandboxApiKey = "cf30giaad3i7csbbscb0"
        static let baseUrl = "https://finnhub.io/api/v1/"
    }
    
    // MARK: - Public
    
    public func search(query: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = url(for: .search, queryParams: ["q": safeQuery]) else { return }
        request(url: url, expecting: SearchResponse.self, completion: completion)
    }
    
    public func news(for type: NewsViewController.`Type`, completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        switch type {
        case .topStories:
            let url = url(for: .topStories, queryParams: ["category": "general"])
            request(url: url, expecting: [NewsStory].self, completion: completion)
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(60 * 60 * 24 * 30))
            let url = url(for: .companyNews, queryParams: [
                "symbol": symbol,
                "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                "to": DateFormatter.newsDateFormatter.string(from: today)
            ])
            
            request(url: url, expecting: [NewsStory].self, completion: completion)
        }
    }
    
    public func markedData(for symbol: String, numberOfDays: TimeInterval = 7, completion: @escaping (Result<MarketDataResponse, Error>) -> Void) {
        let today = Date()
        let prior = today.addingTimeInterval(-60 * 60 * 24 * numberOfDays)
        let url = url(for: .marketData,
                      queryParams: [
                        "symbol": symbol,
                        "resolution": "1",
                        "from": "\(Int(prior.timeIntervalSince1970))",
                        "to": "\(Int(today.timeIntervalSince1970))"
                      ])
        
        request(url: url, expecting: MarketDataResponse.self, completion: completion)
    }
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
    }
    
    private enum APIError: Error {
        case invalidURL
        case canNotDecodeData(String)
        case canNotGetDataFromServer
    }
    
    private func url(for endpoint: Endpoint, queryParams: [String: String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        var queryItems = [URLQueryItem]()
        
        for (key, value) in queryParams {
            queryItems.append(.init(name: key, value: value))
        }
        
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        let queryString = queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        urlString += "?" + queryString
        
        return URL(string: urlString)
    }
    
    private func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? APIError.canNotGetDataFromServer))
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.canNotDecodeData(error.localizedDescription)))
            }
        }.resume()
    }
}
