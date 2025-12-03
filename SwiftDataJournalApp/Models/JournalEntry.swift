//
//  JournalEntry.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/2/25.
//

import Foundation
import SwiftData

// An individual journal entry containing title, content, and metadata
@Model
class JournalEntry {
    var title: String      // Entry title/headline
    var body: String       // Main content/text of the entry
    var createdDate: Date  // Auto-sets to current date when created
    
    // Link to the Journal this entry belongs to (optional)
    // This creates the "backward" connection in Journal → Entry relationship
    var journal: Journal?
    
    // Creates a new journal entry, auto-setting creation date
    init(title: String, body: String, journal: Journal? = nil) {
        self.title = title
        self.body = body
        self.createdDate = Date()  // Auto-set to current date/time
        self.journal = journal     // Link to containing journal
    }
}

