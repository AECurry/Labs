//
//  MediaType.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/13/25.
//

import Foundation

// Defines the different types of media that can be searched in the iTunes Store
enum MediaType: String, CaseIterable {
    case music      // Represents music content (songs, albums, artists)
    case movies     // Represents movie content (films, videos)
    case apps       // Represents mobile applications
    case books      // Represents books and audiobooks
}

