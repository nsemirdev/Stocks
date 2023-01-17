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
        guard let url = url(for: .search, queryParams: ["q": query]) else { return }
        request(url: url, expecting: SearchResponse.self, completion: completion)
    }
    
    // MARK: - Private
    
    private enum Endpoint: String {
        case search
    }
    
    private enum APIError: Error {
        case invalidURL
        case canNotDecodeData
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
                completion(.failure(APIError.canNotDecodeData))
            }
        }.resume()
    }
}
