//
//  Journal.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/3/25.
//

import Foundation
import SwiftData

// A journal/notebook that can contain multiple entries
@Model
class Journal {
    var title: String      // Journal name
    var createdAt: Date    // Auto-sets to current date when created
    var color: String      // Hex color for visual distinction (optional)
    
    // Link to the User who owns this journal (optional)
    // This creates the "backward" connection in User → Journal relationship
    var user: User?
    
    // Link to all entries in this journal
    // .cascade: Deleting this journal also deletes all its entries
    // inverse: Creates two-way connection with JournalEntry.journal
    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.journal)
    var entries: [JournalEntry] = []
    
    // Creates a new journal, auto-setting creation date
    init(title: String, user: User? = nil, color: String = "#007AFF") {
        self.title = title
        self.createdAt = Date()  // Auto-set to current date/time
        self.user = user
        self.color = color
    }
}

