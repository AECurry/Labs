//
//  User.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/2/25.
//

import Foundation
import SwiftData

// A user/person who can create and own multiple journals
@Model
class User {
    var name: String      // User's display name
    var createdAt: Date   // Auto-sets to current date when user is created
    
    // Link to all journals owned by this user
    // .cascade: Deleting this user also deletes all their journals (and entries)
    // inverse: Creates two-way connection with Journal.user
    @Relationship(deleteRule: .cascade, inverse: \Journal.user)
    var journals: [Journal] = []
    
    // Creates a new user, auto-setting creation date
    init(name: String) {
        self.name = name
        self.createdAt = Date()  // Auto-set to current date/time
    }
}

