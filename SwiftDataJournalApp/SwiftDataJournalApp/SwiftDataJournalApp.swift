//
//  SwiftDataJournalAppApp.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/2/25.
//

import SwiftUI
import SwiftData

// @main marks this as the entry point of the app
@main
struct SwiftDataJournalAppApp: App {
    var body: some Scene {
        // WindowGroup is the container for the app's main window
        WindowGroup {
            // UsersView is the first view shown when app launches
            UsersView()
        }
        // .modelContainer sets up SwiftData persistence for these model types
        // This creates the database and makes it available to all views via @Environment
        .modelContainer(for: [User.self, JournalEntry.self, JournalEntry.self])
    }
}

