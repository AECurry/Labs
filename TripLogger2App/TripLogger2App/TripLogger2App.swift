//
//  TripLogger2App.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/15/26.
//

import SwiftUI
import SwiftData

@main
struct TripLogger2App: App {
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
        .modelContainer(for: [Trip.self, JournalEntry.self])
        // Add auto-save configuration
        .modelContainer(for: [Trip.self, JournalEntry.self],
                       isUndoEnabled: false,
                       onSetup: { result in
            switch result {
            case .success(let container):
                container.mainContext.autosaveEnabled = true
                print("SwiftData container configured with autosave")
            case .failure(let error):
                print("Failed to configure SwiftData: \(error)")
            }
        })
    }
}
