//
//  ServiceProtocols.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import Foundation


protocol APIServiceProtocol {
    func fetchUsers(settings: Settings) async throws -> [User]
}


protocol ImageServiceProtocol {
    func loadImage(from urlString: String) async -> Data?
    func cacheImage(_ data: Data, for key: String)
}


protocol StorageServiceProtocol {
    func save<T: Encodable>(_ object: T, for key: String) throws
    func load<T: Decodable>(_ type: T.Type, for key: String) throws -> T?
}


enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check your connection."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Failed to process data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

