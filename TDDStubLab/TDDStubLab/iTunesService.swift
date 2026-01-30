//
//  iTunesService.swift
//  TDDStubLab
//
//  Created by AnnElaine on 1/26/26.
//

import Foundation

protocol iTunesService {
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem]
}
