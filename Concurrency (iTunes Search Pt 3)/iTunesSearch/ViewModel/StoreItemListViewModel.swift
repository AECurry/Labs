//
//  StoreItemListViewModel.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/14/25.
//

import Foundation
import AVFoundation

@Observable
@MainActor
class StoreItemListViewModel {
    var items: [StoreItem] = []
    var searchText: String = ""
    var selectedMediaType: MediaType = .music
    var isLoading = false
    
    let storeItemController = StoreItemController()
    var previewTask: Task<Void, Never>? = nil
    var previewPlayer: AVPlayer?
    
    func fetchMatchingItems() {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        
        var query: [String: String] = [
            "term": searchText,
            "limit": "25",
            "lang": "en_us"
        ]
        
        switch selectedMediaType {
        case .music:
            query["media"] = "music"
            query["entity"] = "song"
            
        case .movies:
            query["media"] = "movie"
            query["entity"] = "movie"
            
        case .apps:
            query["media"] = "software"
            query["entity"] = "software"
            
        case .books:
            query["media"] = "ebook"
            query["entity"] = "ebook"
        }
        
        Task {
            do {
                let fetchedItems = try await storeItemController.fetchItems(matching: query)
                self.items = fetchedItems
            } catch {
                print("Error fetching items: \(error.localizedDescription)")
                self.items = []
            }
            
            isLoading = false
        }
    }
    
    func fetchPreview(item: StoreItem) {
        previewPlayer?.pause()
        previewPlayer = nil
        previewTask?.cancel()
        
        previewTask = Task {
            guard let previewUrl = item.previewUrl else { return }
            
            do {
                let data = try await storeItemController.fetchPreview(from: previewUrl)
                let tempDirectory = FileManager.default.temporaryDirectory
                let tempFileUrl = tempDirectory.appendingPathComponent(previewUrl.lastPathComponent)
                try data.write(to: tempFileUrl)
                
                self.previewPlayer = AVPlayer(url: tempFileUrl)
                self.previewPlayer?.play()
            } catch {
                print("Failed to play preview: \(error.localizedDescription)")
            }
        }
    }
}
