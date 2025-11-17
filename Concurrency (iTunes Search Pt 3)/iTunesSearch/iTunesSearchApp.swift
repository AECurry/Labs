//
//  iTunesSearchApp.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/3/25.
//

import SwiftUI

@main
struct iTunesSearchApp: App {
    init() {
        // Configure URL cache for better performance
        URLCache.shared.memoryCapacity = 25_000_000  // 25 MB
        URLCache.shared.diskCapacity = 50_000_000     // 50 MB
    }
    
    var body: some Scene {
        WindowGroup {
            StoreItemListView()
        }
    }
}
