//
//  DailyContent.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

// MARK: - Core Data Models
/// This file creates a flexible system for organizing daily lesson content.
/// Think of it like a digital lesson planner with different sections (categories) that teachers can fill out.
/// Used for teacher content management and student daily view display
struct DailyContent: Identifiable, Codable, Equatable {
    // MARK: - Core Properties
    let id: String              // Unique identifier for this day's content
    let date: Date              // The instructional date this content applies to
    var entries: [ContentEntry] // Individual content items for this day
    var lastUpdated: Date       // When this content was last modified
    var updatedBy: String       // Teacher ID or name who made the last update
    
    // MARK: - Initializer
    /// Creates daily content with sensible defaults
    /// Allows partial content creation with empty entries and auto-generated timestamps
    init(id: String = UUID().uuidString,
         date: Date,
         entries: [ContentEntry] = [],
         lastUpdated: Date = Date(),
         updatedBy: String = "") {
        self.id = id
        self.date = date
        self.entries = entries
        self.lastUpdated = lastUpdated
        self.updatedBy = updatedBy
    }
}

/// Represents a single piece of instructional content within a daily lesson
/// Each entry belongs to a specific category (e.g., "Word of the Day", "Code Challenge")
struct ContentEntry: Identifiable, Codable, Equatable {
    // MARK: - Core Properties
    let id: String              // Unique identifier for this content piece
    let categoryId: String      // Links to the ContentCategory this entry belongs to
    var content: String         // The actual text/content of this entry
    var links: [ContentLink]    // Related URLs and resources
    let displayOrder: Int       // Determines visual ordering in the UI
    
    // MARK: - Initializer
    /// Creates a content entry with category association and display position
    init(id: String = UUID().uuidString,
         categoryId: String,
         content: String = "",
         links: [ContentLink] = [],
         displayOrder: Int) {
        self.id = id
        self.categoryId = categoryId
        self.content = content
        self.links = links
        self.displayOrder = displayOrder
    }
}

/// Represents an external resource link within content entries
/// Used for supplementary materials, documentation, and online resources
struct ContentLink: Identifiable, Codable, Equatable {
    // MARK: - Core Properties
    let id: String      // Unique identifier for this link
    let title: String   // Display title for the link
    let url: String     // The actual URL destination
    
    // MARK: - Initializer
    /// Creates a titled URL resource for supplementary materials
    init(id: String = UUID().uuidString, title: String, url: String) {
        self.id = id
        self.title = title
        self.url = url
    }
}

// MARK: - Category Configuration (Open/Closed Principle)
/// Defines types of content that can be added to daily lessons
/// Follows Open/Closed Principle - categories can be extended without modifying existing code
struct ContentCategory: Identifiable, Codable, Equatable {
    // MARK: - Core Properties
    let id: String                      // Unique category identifier
    let title: String                   // Display name (e.g., "Word of the Day")
    let placeholder: String             // Hint text for empty content fields
    let isEnabled: Bool                 // Whether this category is active/visible
    let displayOrder: Int               // Determines category ordering in UI
    let allowsMultipleEntries: Bool     // Whether multiple entries per category are allowed
    let inputType: InputType            // What kind of content this category accepts
    
    // MARK: - Input Type Enum
    /// Defines what type of content input each category uses
    /// Controls UI presentation and content validation
    enum InputType: String, Codable {
        case text, richText, link
    }
    
    // MARK: - Initializer
    /// Creates a content category with configuration for display and behavior
    init(id: String = UUID().uuidString,
         title: String,
         placeholder: String = "",
         isEnabled: Bool = true,
         displayOrder: Int,
         allowsMultipleEntries: Bool = false,
         inputType: InputType = .text) {
        self.id = id
        self.title = title
        self.placeholder = placeholder
        self.isEnabled = isEnabled
        self.displayOrder = displayOrder
        self.allowsMultipleEntries = allowsMultipleEntries
        self.inputType = inputType
    }
}

// MARK: - Default Categories
extension ContentCategory {
    /// Predefined content categories covering typical daily instructional elements
    /// Provides structured organization for lesson planning and content entry
    static let defaultCategories: [ContentCategory] = [
        ContentCategory(
            id: "word_of_day", // ← Same ID as mock data for consistency
            title: "Word of the Day",
            placeholder: "Enter word of the day...",
            displayOrder: 0
        ),
        ContentCategory(
            title: "Instructor",
            placeholder: "Enter instructor name...",
            displayOrder: 1
        ),
        ContentCategory(
            title: "Code Challenge",
            placeholder: "Enter code challenge...",
            displayOrder: 2
        ),
        ContentCategory(
            title: "Topic/Outline",
            placeholder: "Enter topics/outline...",
            displayOrder: 3
        ),
        ContentCategory(
            title: "Labs/Projects Due",
            placeholder: "Enter labs/projects due...",
            displayOrder: 4
        ),
        ContentCategory(
            title: "Reading/Hybrid Work",
            placeholder: "Enter reading assignments...",
            displayOrder: 5
        ),
        ContentCategory(
            title: "Review Topic",
            placeholder: "Enter review topics...",
            displayOrder: 6
        )
    ]
}

// MARK: - Helper Extensions
extension DailyContent {
    /// Finds a specific content entry by its category identifier
    /// Returns nil if no entry exists for the given category
    func entry(for categoryId: String) -> ContentEntry? {
        entries.first { $0.categoryId == categoryId }
    }
}

extension ContentEntry {
    /// Retrieves the category definition for this content entry
    /// Useful for determining display properties and validation rules
    func category(from categories: [ContentCategory]) -> ContentCategory? {
        categories.first { $0.id == categoryId }
    }
}
