//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        
    }
    
    // MARK: - Public
    
    public var watchlist: [String] {
        []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func remoteFromWatchlist() {
        
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        false
    }
}
