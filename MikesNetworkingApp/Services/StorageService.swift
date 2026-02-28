//
//  StorageService.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import Foundation

final class StorageService: StorageServiceProtocol {
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Encodable>(_ object: T, for key: String) throws {
        let data = try encoder.encode(object)
        defaults.set(data, forKey: key)
    }
    
    func load<T: Decodable>(_ type: T.Type, for key: String) throws -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try decoder.decode(type, from: data)
    }
    
    // Optional: Remove saved data
    func remove(for key: String) {
        defaults.removeObject(forKey: key)
    }
    
    // Optional: Check if key exists
    func exists(for key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
}

