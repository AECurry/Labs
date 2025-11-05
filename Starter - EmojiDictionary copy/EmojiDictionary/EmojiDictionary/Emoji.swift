//
//  Emoji.swift
//  EmojiDictionary
//
//  Created by Jane Madsen on 10/30/25.
//

import Foundation

/**
 A model representing an emoji with its properties and persistence capabilities.
 
 This struct conforms to both Codable (for serialization) and Identifiable
 (for SwiftUI list management) protocols.
 */
struct Emoji: Codable, Identifiable {
    
    // MARK: - Properties
    
    /// Unique identifier for each emoji, automatically generated
    var id: UUID = UUID()
    
    /// The actual emoji character (e.g., "😀", "🐢")
    var symbol: String
    
    /// The descriptive name of the emoji (e.g., "Grinning Face", "Turtle")
    var name: String
    
    /// A detailed description explaining what the emoji represents
    var description: String
    
    /// Common usage contexts or meanings for the emoji
    var usage: String
    
    // MARK: - File Management
    
    /**
     The URL where emoji data will be persistently stored.
     
     This computed property returns a file URL in the app's Documents directory
     with the filename "emojis.plist". The Documents directory is preserved
     between app launches and is backed up to iCloud.
     */
    static let archiveURL: URL = {
        // Get the app's Documents directory
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        
        // Append our specific filename with .plist extension
        return documentsDirectory
            .appendingPathComponent("emojis")
            .appendingPathExtension("plist")
    }()
    
    // MARK: - Data Persistence Methods
    
    /**
     Saves an array of Emoji objects to persistent storage.
     
     This method encodes the emojis array to property list format and writes
     it to the archiveURL location. If saving fails, an error is logged.
     
     - Parameter emojis: The array of Emoji objects to save
     */
    static func saveToFile(emojis: [Emoji]) {
        // Create a PropertyListEncoder for serialization
        let encoder = PropertyListEncoder()
        
        // Use XML format for human-readable output (helps with debugging)
        encoder.outputFormat = .xml
        
        do {
            // Attempt to encode the emojis array to Data
            let data = try encoder.encode(emojis)
            
            // Write the encoded data to disk at the archiveURL location
            // Using .noFileProtection to ensure the file is accessible even if the device is locked
            try data.write(to: archiveURL, options: .noFileProtection)
            
            // Log success for debugging purposes
            print("✅ Successfully saved \(emojis.count) emojis to \(archiveURL)")
            
        } catch {
            // Log any errors that occur during encoding or writing
            print("❌ Error saving emojis: \(error.localizedDescription)")
            // In a production app, you might want to show an alert to the user here
        }
    }
    
    /**
     Loads an array of Emoji objects from persistent storage.
     
     This method attempts to read and decode previously saved emoji data.
     It includes comprehensive error handling for various failure scenarios.
     
     - Returns: An optional array of Emoji objects, or nil if loading fails
     */
    static func loadFromFile() -> [Emoji]? {
        let fileManager = FileManager.default
        
        // First, check if the file actually exists at the expected path
        guard fileManager.fileExists(atPath: archiveURL.path) else {
            print("📝 No saved emojis file found at \(archiveURL.path). This is normal on first launch.")
            return nil
        }
        
        // Verify that the file is readable (permissions check)
        guard fileManager.isReadableFile(atPath: archiveURL.path) else {
            print("❌ File exists but is not readable at \(archiveURL.path)")
            return nil
        }
        
        do {
            // Read the raw data from the file
            let data = try Data(contentsOf: archiveURL)
            
            // Check if the file contains actual data (not just an empty file)
            guard !data.isEmpty else {
                print("⚠️ File exists but contains no data")
                return nil
            }
            
            // Create a decoder to convert Data back to Emoji objects
            let decoder = PropertyListDecoder()
            
            // Attempt to decode the data into an array of Emoji objects
            let decodedEmojis = try decoder.decode([Emoji].self, from: data)
            
            // Log success and return the decoded array
            print("✅ Successfully loaded \(decodedEmojis.count) emojis from file")
            return decodedEmojis
            
        } catch let error as DecodingError {
            // Handle specific decoding errors with detailed information
            
            switch error {
            case .dataCorrupted(let context):
                print("❌ Data corrupted: \(context.debugDescription)")
                print("Coding path: \(context.codingPath)")
                
            case .keyNotFound(let key, let context):
                print("❌ Key '\(key)' not found: \(context.debugDescription)")
                print("Coding path: \(context.codingPath)")
                
            case .typeMismatch(let type, let context):
                print("❌ Type '\(type)' mismatch: \(context.debugDescription)")
                print("Coding path: \(context.codingPath)")
                
            case .valueNotFound(let type, let context):
                print("❌ Value '\(type)' not found: \(context.debugDescription)")
                print("Coding path: \(context.codingPath)")
                
            @unknown default:
                print("❌ Unknown decoding error: \(error.localizedDescription)")
            }
            
            // Attempt to recover by moving the corrupted file
            handleCorruptedFile()
            return nil
            
        } catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoPermissionError {
            // Handle file permission errors specifically
            print("❌ No permission to read file: \(archiveURL.path)")
            return nil
            
        } catch {
            // Catch any other unexpected errors
            print("❌ Unexpected error loading emojis: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Error Recovery
    
    /**
     Handles corrupted data files by moving them to a backup location.
     
     This method renames corrupted files with a timestamp to prevent them
     from interfering with future app launches while preserving the original
     file for debugging purposes.
     */
    private static func handleCorruptedFile() {
        let fileManager = FileManager.default
        
        // Create a backup filename with timestamp to avoid naming conflicts
        let timestamp = Date().timeIntervalSince1970
        let backupURL = archiveURL
            .deletingLastPathComponent()
            .appendingPathComponent("emojis_corrupted_\(timestamp).plist")
        
        do {
            // Move the corrupted file to backup location
            try fileManager.moveItem(at: archiveURL, to: backupURL)
            print("⚠️ Moved corrupted file to backup location: \(backupURL.lastPathComponent)")
            
        } catch {
            // Log if moving the corrupted file also fails
            print("❌ Could not move corrupted file: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Sample Data
    
    /**
     Provides a default set of emojis for first-time app usage.
     
     This method returns a predefined array of Emoji objects that are displayed
     when no previously saved data exists. This ensures the app has content
     immediately upon first launch.
     
     - Returns: An array of sample Emoji objects
     */
    static func sampleEmojis() -> [Emoji] {
        return [
            Emoji(
                symbol: "😀",
                name: "Grinning Face",
                description: "A typical smiley face.",
                usage: "happiness"
            ),
            Emoji(
                symbol: "🐢",
                name: "Turtle",
                description: "A cute turtle.",
                usage: "slow and steady"
            ),
            Emoji(
                symbol: "🍕",
                name: "Pizza",
                description: "A delicious slice of pizza.",
                usage: "food cravings"
            ),
            Emoji(
                symbol: "❤️",
                name: "Heart",
                description: "Represents love.",
                usage: "love and affection"
            ),
            Emoji(
                symbol: "⚡️",
                name: "Lightning Bolt",
                description: "A flash of lightning.",
                usage: "energy or power"
            )
        ]
    }
}

// MARK: - Convenience Extensions

extension Emoji {
    /**
     Convenience initializer for creating Emoji instances with all properties.
     
     - Parameters:
        - symbol: The emoji character
        - name: The descriptive name
        - description: Detailed explanation
        - usage: Common usage contexts
     */
    init(symbol: String, name: String, description: String, usage: String) {
        self.id = UUID()
        self.symbol = symbol
        self.name = name
        self.description = description
        self.usage = usage
    }
}
