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
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseUrl = ""
    }
    
    // MARK: - Public
    
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
        return nil
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
