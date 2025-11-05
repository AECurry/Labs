//
//  StoreItem.swift
//  iTunesSearchLab
//
//  Created by AnnElaine Curry on 11/4/25.
//

import Foundation

// MARK: - Data Models

/// Represents a single item from iTunes Search (song, ebook, movie, etc.)
struct StoreItem: Codable {
    let name: String          // Item title (song name, book title, etc.)
    let artist: String        // Creator (artist, author, etc.)
    let description: String   // Item description with fallback logic
    let artworkURL: URL       // Image URL for display
    let mediaType: String     // Type of media (song, ebook, movie)
    
    /// Maps JSON field names to our Swift property names
    enum CodingKeys: String, CodingKey {
        case name = "trackName"        // JSON: "trackName" → Swift: name
        case artist = "artistName"     // JSON: "artistName" → Swift: artist
        case artworkURL = "artworkUrl100" // JSON: "artworkUrl100" → Swift: artworkURL
        case mediaType = "kind"        // JSON: "kind" → Swift: mediaType
        case description = "description" // JSON: "description" → Swift: description
    }
    
    /// Backup keys for when description isn't available
    enum AdditionalKeys: String, CodingKey {
        case longDescription = "longDescription" // Fallback description field
    }
    
    /// Custom decoder handles description/longDescription fallback
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        artist = try values.decode(String.self, forKey: .artist)
        artworkURL = try values.decode(URL.self, forKey: .artworkURL)
        mediaType = try values.decode(String.self, forKey: .mediaType)
        
        // Try regular description first, fall back to longDescription if needed
        if let description = try? values.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            self.description = (try? additionalValues.decode(String.self, forKey: .longDescription)) ?? "No description"
        }
    }
}

/// Top-level container for iTunes API response
struct SearchResponse: Codable {
    let results: [StoreItem] // Array of items from search
}

// MARK: - Network Operations

/// Custom errors for search operations
enum StoreItemError: Error, LocalizedError {
    case itemsNotFound // When API returns no results or fails
}

/// Fetches items from iTunes Search API and returns decoded objects
func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
    // Build URL with search parameters
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
    urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
    
    // Make network request
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    // Check for successful HTTP response
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw StoreItemError.itemsNotFound
    }
    
    // Decode JSON into Swift objects
    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
    return searchResponse.results
}
