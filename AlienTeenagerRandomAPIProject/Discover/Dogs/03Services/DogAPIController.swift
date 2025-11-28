//
//  DogAPIController.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import Foundation
import UIKit

/// Concrete implementation of DogAPIControllerProtocol that handles actual API calls to dog.ceo
class DogAPIController: DogAPIControllerProtocol {
    
    // MARK: - Properties
    private let baseURL = URL(string: "https://dog.ceo/api/breeds/image/random")!
    
    // MARK: - Public Methods
    
    func fetchRandomDogImage() async throws -> UIImage {
        // Step 1: Fetch the random dog image URL from the API
        let imageURL = try await fetchRandomDogImageURL()
        
        // Step 2: Download the actual image data
        return try await downloadImage(from: imageURL)
    }
    
    // MARK: - Private Methods
    
    /// Fetches a random dog image URL from the dog.ceo API
    private func fetchRandomDogImageURL() async throws -> URL {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Handle rate limiting
        if httpResponse.statusCode == 429 {
            throw URLError(.resourceUnavailable)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        
        // Parse the JSON response
        let decoder = JSONDecoder()
        let dogResponse = try decoder.decode(DogAPIResponse.self, from: data)
        
        // Convert the string URL to a URL object
        guard let imageURL = URL(string: dogResponse.message) else {
            throw URLError(.badURL)
        }
        
        return imageURL
    }
    
    /// Downloads image data from a given URL and converts it to UIImage
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for HTTP response errors
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Convert data to UIImage
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return image
    }
}

// MARK: - Supporting Data Models

/// Response model for the dog.ceo API random image endpoint
struct DogAPIResponse: Codable {
    let message: String
    let status: String
}

