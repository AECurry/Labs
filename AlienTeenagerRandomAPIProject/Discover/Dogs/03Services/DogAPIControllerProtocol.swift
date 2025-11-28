//
//  DogAPIControllerProtocol.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import Foundation
import UIKit

/// Protocol defining the interface for Dog API operations
protocol DogAPIControllerProtocol {
    
    /// Fetches a random dog image from the API
    /// - Parameter completion: Async result with UIImage on success, Error on failure
    func fetchRandomDogImage() async throws -> UIImage
    
    // Note: We might add more methods later for other dog-related API operations
}

