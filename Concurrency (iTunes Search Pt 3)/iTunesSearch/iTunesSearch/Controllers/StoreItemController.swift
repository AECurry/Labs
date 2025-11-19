//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/14/25.
//

import Foundation

// Network controller class responsible for all API communications with iTunes
class StoreItemController {
    
    /// Fetches store items from iTunes Search API based on provided query parameters
    /// - Parameter query: Dictionary of query parameters (term, media, entity, limit, etc.)
    /// - Returns: Array of StoreItem objects decoded from the API response
    /// - Throws: URLError for network issues or decoding failures
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        // Create URLComponents to safely construct the URL with query parameters
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        
        // Convert dictionary of query parameters to URLQueryItem array
        // Example: ["term": "swift", "media": "music"] becomes:
        // [URLQueryItem(name: "term", value: "swift"), URLQueryItem(name: "media", value: "music")]
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Safely unwrap the constructed URL
        guard let url = urlComponents.url else {
            // Throw error if URL construction fails (should rarely happen with valid components)
            throw URLError(.badURL)
        }
        
        // Perform asynchronous network request using URLSession
        // This suspends the function until data is received or error occurs
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verify we received a valid HTTP response with status code 200 (OK)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            // Throw error for non-200 status codes (404, 500, etc.)
            throw URLError(.badServerResponse)
        }
        
        // Decode the JSON response into Swift objects
        let decoder = JSONDecoder()
        
        // Decode the top-level SearchResponse which contains the results array
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        
        // Return the array of StoreItem objects from the decoded response
        return searchResponse.results
    }
    
    /// Fetches preview data (audio/video) from a given URL
    /// - Parameter url: The URL pointing to the preview media file
    /// - Returns: Raw Data object containing the preview file contents
    /// - Throws: URLError for network issues or invalid responses
    func fetchPreview(from url: URL) async throws -> Data {
        // Perform asynchronous network request to fetch preview data
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verify we received a valid HTTP response with status code 200 (OK)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Return the raw binary data (audio file, video file, etc.)
        return data
    }
}

