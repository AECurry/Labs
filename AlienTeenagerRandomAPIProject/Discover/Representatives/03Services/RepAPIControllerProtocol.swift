//
//  RepAPIControllerProtocol.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import Foundation

/// Protocol defining the interface for Representative API operations
protocol RepAPIControllerProtocol {
    
    /// Fetches representatives for a given zip code
    /// - Parameter zipCode: The zip code to search for
    /// - Returns: Array of Representative objects
    func fetchRepresentatives(for zipCode: String) async throws -> [Representative]
}
