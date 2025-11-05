//
//  ContentView.swift
//  iTunesSearchLab
//
//  Created by AnnElaine Curry on 11/3/25.
//

import SwiftUI

/// Main screen - displays search results in console
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("iTunes Search Lab")
                .font(.title)
            Text("Part 2 - Decoded Objects") // Shows we're displaying objects, not raw JSON
                .font(.subheadline)
        }
        .padding()
        .onAppear {
            performSearch() // Start search when screen loads
        }
    }
    
    /// Executes search and displays formatted results
    func performSearch() {
        // Search for Apple ebooks (lab requirement)
        let query = [
            "term": "Apple",   // Search query
            "media": "ebook",  // Media type filter
            "limit": "10"      // Number of results
        ]
        
        // Async task for network call
        Task {
            do {
                // Fetch and decode items
                let items = try await fetchItems(matching: query)
                
                // Display formatted results
                print("🎉 SUCCESS: Decoded \(items.count) StoreItem Objects")
                print("========================================")
                
                for item in items {
                    print("""
                    Name: \(item.name)
                    Artist: \(item.artist)
                    Type: \(item.mediaType)
                    Description: \(item.description)
                    Artwork: \(item.artworkURL)
                    --------------------
                    """)
                }
                print("🎯 Part 2 Complete - Raw JSON → Typed Swift Objects!")
                
            } catch {
                print("❌ Search failed: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
