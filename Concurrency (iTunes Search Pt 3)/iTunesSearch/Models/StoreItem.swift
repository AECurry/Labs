//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/13/25.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [StoreItem]
}

struct StoreItem: Decodable, Hashable {
    let name: String
    let artist: String
    let description: String
    let artworkURL: URL?
    let mediaType: String
    let previewUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case collectionName
        case trackCensoredName
        case collectionCensoredName
        case artistName
        case collectionArtistName
        case artworkUrl100
        case kind
        case wrapperType
        case previewUrl
        case trackViewUrl
        case collectionViewUrl
        case longDescription
        case description
        case shortDescription
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try multiple name fields
        if let trackName = try? container.decode(String.self, forKey: .trackName) {
            name = trackName
        } else if let collectionName = try? container.decode(String.self, forKey: .collectionName) {
            name = collectionName
        } else if let trackCensored = try? container.decode(String.self, forKey: .trackCensoredName) {
            name = trackCensored
        } else if let collectionCensored = try? container.decode(String.self, forKey: .collectionCensoredName) {
            name = collectionCensored
        } else {
            name = "Unknown Title"
        }
        
        // Try multiple artist fields
        if let artistName = try? container.decode(String.self, forKey: .artistName) {
            artist = artistName
        } else if let collectionArtist = try? container.decode(String.self, forKey: .collectionArtistName) {
            artist = collectionArtist
        } else {
            artist = "Unknown Creator"
        }
        
        artworkURL = try? container.decode(URL.self, forKey: .artworkUrl100)
        
        if let kind = try? container.decode(String.self, forKey: .kind) {
            mediaType = kind
        } else if let wrapper = try? container.decode(String.self, forKey: .wrapperType) {
            mediaType = wrapper
        } else {
            mediaType = "unknown"
        }
        
        // Try multiple preview URL fields
        if let preview = try? container.decode(URL.self, forKey: .previewUrl) {
            previewUrl = preview
        } else if let trackView = try? container.decode(URL.self, forKey: .trackViewUrl) {
            previewUrl = trackView
        } else if let collectionView = try? container.decode(URL.self, forKey: .collectionViewUrl) {
            previewUrl = collectionView
        } else {
            previewUrl = nil
        }
        
        // Try multiple description fields
        if let longDesc = try? container.decode(String.self, forKey: .longDescription) {
            description = longDesc
        } else if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        } else if let shortDesc = try? container.decode(String.self, forKey: .shortDescription) {
            description = shortDesc
        } else {
            description = "No description available"
        }
    }
}
