//
//  iTunesSearchApp.swift
//  TDDStubLab
//
//  Created by AnnElaine on 1/26/26.
//

import SwiftUI

// MARK: - App Entry Point
// The @main attribute identifies this struct as the application's entry point
// When the app launches, SwiftUI looks for a type marked with @main and runs it
@main
struct iTunesSearchApp: App {
    
    // MARK: - App Initialization
    // Custom initializer for app-level configuration
    init() {
        // Configure URL cache for better performance
        // This cache stores network responses (like images from iTunes API) to improve performance
        URLCache.shared.memoryCapacity = 25_000_000  // 25 MB of in-memory cache
        URLCache.shared.diskCapacity = 50_000_000     // 50 MB of disk cache
        
        // Benefits of URL caching:
        // - Faster image loading (artwork doesn't need to be re-downloaded)
        // - Reduced network usage
        // - Better performance on slow connections
        // - Automatic cache management by iOS
    }
    
    // MARK: - App Scene Configuration
    // The body property defines the app's content and structure
    var body: some Scene {
        // WindowGroup represents the main window of the app
        // On iOS, this typically represents the entire app screen
        // On macOS, this can create multiple windows
        WindowGroup {
            // StoreItemListView is the root view of the application
            // This is the first screen users see when the app launches
            iTunesListView()
            
            // This view contains:
            // - Navigation bar with title "iTunes Search"
            // - Segmented control for media types (Music, Movies, Apps, Books)
            // - Search bar for entering queries
            // - List view for displaying search results
            // - Audio preview functionality
        }
    }
}

