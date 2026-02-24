//
//  User.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

import Foundation
import SwiftData

@Model // SwiftData macro - makes this class persistable
final class User {
    var name: String      // The user's name
    var createdAt: Date   // Used for sorting/ordering
    
    init(name: String) {
        self.name = name
        self.createdAt = Date() // Sets timestamp when user is created
    }
}
