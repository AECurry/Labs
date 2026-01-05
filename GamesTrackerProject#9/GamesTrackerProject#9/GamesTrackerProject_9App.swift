//
//  GamesTrackerProject_9App.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/10/25.
//

import SwiftUI
import SwiftData

@main
struct GamesTrackerProject_9App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Game.self,
            Team.self,
            Student.self,
            PlayerScore.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            GamesTrackerMainView()
                .modelContainer(sharedModelContainer)
        }
    }
}
