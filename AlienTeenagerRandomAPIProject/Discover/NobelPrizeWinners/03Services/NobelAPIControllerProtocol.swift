//
//  NobelAPIControllerProtocol.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import Foundation

/// Protocol defining the interface for Nobel Prize API operations
protocol NobelAPIControllerProtocol {
    
    /// Fetches Nobel prizes with optional filters
    /// - Parameters:
    ///   - year: Optional year filter (e.g., "2020")
    ///   - category: Optional category filter (e.g., "physics")
    ///   - limit: Maximum number of results to return
    /// - Returns: Array of NobelPrize objects
    func fetchNobelPrizes(year: String?, category: String?, limit: Int) async throws -> [NobelPrize]
    
    /// Fetches all available Nobel prize categories
    /// - Returns: Array of category names
    func fetchCategories() async throws -> [String]
}

