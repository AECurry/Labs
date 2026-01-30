//
//  StoreItem.swift
//  TDDStubLab
//
//  Created by AnnElaine on 1/26/26.
//

import Foundation

// Represents the top-level response from the iTunes Search API
struct SearchResponse: Decodable {
    let results: [StoreItem]  // Array of store items returned from the search
}

// Represents an individual item from the iTunes Store (song, app, movie, book, etc.)
struct StoreItem: Decodable, Hashable {
    // Core properties that will be displayed in the UI
    let name: String          // The title/name of the item (song name, app name, etc.)
    let artist: String        // The creator (artist, developer, author, etc.)
    let description: String   // Description or details about the item
    let artworkURL: URL?      // URL to the item's artwork/image (optional - might be missing)
    let mediaType: String     // The type of media (song, feature-movie, software, etc.)
    let previewUrl: URL?      // URL for audio/video preview (optional - not all items have previews)
    
    // Maps JSON key names to Swift property names
    // iTunes API uses different field names than what we want in our app
    enum CodingKeys: String, CodingKey {
        case trackName               // Name for individual tracks (songs, episodes)
        case collectionName          // Name for collections (albums, app bundles)
        case trackCensoredName       // Censored version of track name
        case collectionCensoredName  // Censored version of collection name
        case artistName              // Primary artist name
        case collectionArtistName    // Artist name for collections
        case artworkUrl100           // URL to 100x100 pixel artwork
        case kind                    // Specific media type (song, feature-movie, etc.)
        case wrapperType             // Broad category (track, collection, etc.)
        case previewUrl              // URL to preview media
        case trackViewUrl            // URL to track page in iTunes Store
        case collectionViewUrl       // URL to collection page in iTunes Store
        case longDescription         // Detailed description
        case description             // Standard description
        case shortDescription        // Brief description
    }
    
    // Custom decoding logic to handle the inconsistent iTunes API response structure
    // Different media types (music, movies, apps, books) use different field names for similar data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // NAME EXTRACTION: Try multiple possible fields for the item's name
        // iTunes API uses different name fields depending on the media type
        if let trackName = try? container.decode(String.self, forKey: .trackName) {
            name = trackName
        } else if let collectionName = try? container.decode(String.self, forKey: .collectionName) {
            name = collectionName
        } else if let trackCensored = try? container.decode(String.self, forKey: .trackCensoredName) {
            name = trackCensored
        } else if let collectionCensored = try? container.decode(String.self, forKey: .collectionCensoredName) {
            name = collectionCensored
        } else {
            name = "Unknown Title"  // Fallback if no name fields are found
        }
        
        // ARTIST EXTRACTION: Try multiple possible fields for the creator's name
        if let artistName = try? container.decode(String.self, forKey: .artistName) {
            artist = artistName
        } else if let collectionArtist = try? container.decode(String.self, forKey: .collectionArtistName) {
            artist = collectionArtist
        } else {
            artist = "Unknown Creator"  // Fallback if no artist fields are found
        }
        
        // ARTWORK URL: Get the image URL (fails gracefully if missing)
        artworkURL = try? container.decode(URL.self, forKey: .artworkUrl100)
        
        // MEDIA TYPE: Determine what kind of media this is
        if let kind = try? container.decode(String.self, forKey: .kind) {
            mediaType = kind  // Specific type like "song", "feature-movie"
        } else if let wrapper = try? container.decode(String.self, forKey: .wrapperType) {
            mediaType = wrapper  // Broad category like "track", "collection"
        } else {
            mediaType = "unknown"  // Fallback if type can't be determined
        }
        
        // PREVIEW URL: Try multiple possible fields for preview media
        if let preview = try? container.decode(URL.self, forKey: .previewUrl) {
            previewUrl = preview
        } else if let trackView = try? container.decode(URL.self, forKey: .trackViewUrl) {
            previewUrl = trackView  // Use track page as fallback preview
        } else if let collectionView = try? container.decode(URL.self, forKey: .collectionViewUrl) {
            previewUrl = collectionView  // Use collection page as fallback preview
        } else {
            previewUrl = nil  // No preview available
        }
        
        // DESCRIPTION: Try multiple possible fields for item description
        if let longDesc = try? container.decode(String.self, forKey: .longDescription) {
            description = longDesc
        } else if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        } else if let shortDesc = try? container.decode(String.self, forKey: .shortDescription) {
            description = shortDesc
        } else {
            description = "No description available"  // Fallback description
        }
    }
}

