//
//  StoreItemListViewModel.swift
//  TDDStubLab
//
//  Created by AnnElaine on 1/26/26.
//

import Foundation
import AVFoundation

// Marked as @Observable to enable SwiftUI view updates when properties change
// @MainActor ensures all UI updates happen on the main thread
@Observable
@MainActor
class StoreItemListViewModel {
    // MARK: - Published Properties (Trigger UI Updates)
    
    // Array of store items to display in the list
    var items: [StoreItem] = []
    
    // The current search text from the search bar
    var searchText: String = ""
    
    // The currently selected media type in the segmented control
    var selectedMediaType: MediaType = .music
    
    // Loading state to show/hide progress indicator
    var isLoading = false
    
    // MARK: - Service Dependencies
    
    // Controller that handles actual API network requests
    private let service: iTunesService
    
    // MARK: - Audio Preview Properties
    
    // Task for managing async preview loading (can be cancelled)
    var previewTask: Task<Void, Never>? = nil
    
    // AVPlayer for playing audio previews
    var previewPlayer: AVPlayer?
    
    // MARK: - Initializer
    
    // Dependency injection - can pass any iTunesService implementation
    init(service: iTunesService = StoreItemController()) {
        self.service = service
    }
    
    // MARK: - Search Functionality
    
    /// Fetches items from iTunes API based on current search text and media type
    func fetchMatchingItems() {
        // Don't search if search text is empty or already loading
        guard !searchText.isEmpty && !isLoading else { return }
        
        // Show loading indicator
        isLoading = true
        
        // Base query parameters for iTunes API
        var query: [String: String] = [
            "term": searchText,      // The search query from user input
            "limit": "25",           // Maximum number of results to return
            "lang": "en_us"          // Language and region
        ]
        
        // Configure media-specific parameters based on selected type
        switch selectedMediaType {
        case .music:
            query["media"] = "music"     // Search in music category
            query["entity"] = "song"     // Specifically look for songs
            
        case .movies:
            query["media"] = "movie"     // Search in movies category
            query["entity"] = "movie"    // Look for movies
            
        case .apps:
            query["media"] = "software"  // Search in software category
            query["entity"] = "software" // Look for applications
            
        case .books:
            query["media"] = "ebook"     // Search in eBooks category
            query["entity"] = "ebook"    // Look for eBooks
        }
        
        // Perform the network request asynchronously
        Task {
            do {
                // Attempt to fetch items from the API using the injected service
                let fetchedItems = try await service.fetchItems(matching: query)
                // Update the items array on success (triggers UI update)
                self.items = fetchedItems
            } catch {
                // Handle errors by clearing results and logging
                print("Error fetching items: \(error.localizedDescription)")
                self.items = []  // Clear any previous results
            }
            
            // Hide loading indicator regardless of success/failure
            isLoading = false
        }
    }
    
    // MARK: - Audio Preview Functionality
    
    /// Fetches and plays a preview for the given store item
    /// - Parameter item: The store item to play preview for
    func fetchPreview(item: StoreItem) {
        // Stop any currently playing preview
        previewPlayer?.pause()
        previewPlayer = nil
        
        // Cancel any ongoing preview loading task
        previewTask?.cancel()
        
        // Create new async task for loading the preview
        previewTask = Task {
            // Ensure the item has a preview URL
            guard let previewUrl = item.previewUrl else { return }
            
            do {
                // Fetch preview data from the URL using the StoreItemController
                let controller = StoreItemController()
                let data = try await controller.fetchPreview(from: previewUrl)
                
                // Create temporary file URL for the audio data
                let tempDirectory = FileManager.default.temporaryDirectory
                let tempFileUrl = tempDirectory.appendingPathComponent(previewUrl.lastPathComponent)
                
                // Write audio data to temporary file (required for AVPlayer)
                try data.write(to: tempFileUrl)
                
                // Create and start playing the audio
                self.previewPlayer = AVPlayer(url: tempFileUrl)
                self.previewPlayer?.play()
            } catch {
                // Handle preview loading/playback errors
                print("Failed to play preview: \(error.localizedDescription)")
            }
        }
    }
}
