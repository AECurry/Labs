//
//  ImageCacheService.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import Foundation
import UIKit


final class ImageCacheService: ImageServiceProtocol {
    static let shared = ImageCacheService()
    
    // MARK: - Cache Configuration
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheQueue = DispatchQueue(label: "image.cache.queue", attributes: .concurrent)
    
    private init() {
        memoryCache.countLimit = 100 // Max 100 images in memory
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50MB limit
        
        // Create disk cache directory if needed
        createCacheDirectoryIfNeeded()
    }
    
    // MARK: - Public Methods
    func loadImage(from urlString: String) async -> Data? {
        // Check memory cache first (fastest)
        if let cachedData = getFromMemoryCache(for: urlString) {
            return cachedData
        }
        
        // Check disk cache (slower but persists between sessions)
        if let diskData = try? loadFromDisk(for: urlString) {
            // Store back in memory cache for next time
            saveToMemoryCache(diskData, for: urlString)
            return diskData
        }
        
        // Download from network
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Cache the downloaded image
            saveToMemoryCache(data, for: urlString)
            try? saveToDisk(data, for: urlString)
            
            return data
        } catch {
            print("❌ Failed to download image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func cacheImage(_ data: Data, for key: String) {
        saveToMemoryCache(data, for: key)
        try? saveToDisk(data, for: key)
    }
    
    // MARK: - Memory Cache
    private func getFromMemoryCache(for key: String) -> Data? {
        cacheQueue.sync {
            memoryCache.object(forKey: key as NSString) as? Data
        }
    }
    
    private func saveToMemoryCache(_ data: Data, for key: String) {
        cacheQueue.async(flags: .barrier) { [weak self] in
            self?.memoryCache.setObject(data as NSData, forKey: key as NSString)
        }
    }
    
    // MARK: - Disk Cache
    private func getDiskCacheURL(for key: String) -> URL {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let filename = key
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "?", with: "_")
        return cacheDir.appendingPathComponent(filename)
    }
    
    private func createCacheDirectoryIfNeeded() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let imageCacheDir = cacheDir.appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: imageCacheDir.path) {
            try? fileManager.createDirectory(at: imageCacheDir, withIntermediateDirectories: true)
        }
    }
    
    private func saveToDisk(_ data: Data, for key: String) throws {
        let url = getDiskCacheURL(for: key)
        try data.write(to: url)
    }
    
    private func loadFromDisk(for key: String) throws -> Data? {
        let url = getDiskCacheURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }
    
    // MARK: - Cache Management
    func clearMemoryCache() {
        cacheQueue.async(flags: .barrier) { [weak self] in
            self?.memoryCache.removeAllObjects()
        }
    }
    
    func clearDiskCache() throws {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let contents = try fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
        
        for url in contents {
            try fileManager.removeItem(at: url)
        }
    }
}

