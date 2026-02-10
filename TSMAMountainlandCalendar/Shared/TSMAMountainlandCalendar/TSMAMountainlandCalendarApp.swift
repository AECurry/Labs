//
//  TSMAMountainlandCalendarApp.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI
import SwiftData  // Add this import

@main
struct TSMAMountainlandCalendarApp: App {
    @State private var isAuthenticated = false
    
    // MARK: - SwiftData Container
    /// Provides persistent storage for assignment completion status
    /// Configured to automatically manage Assignment model data
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Assignment.self  // Register our Assignment model with SwiftData
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        // Restore saved session when app launches
        APIController.shared.restoreSession()
        // Check if we have a valid session
        isAuthenticated = APIController.shared.isAuthenticated
    }
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                MainTabView()
                    .modelContainer(sharedModelContainer)  // Add SwiftData to authenticated views
            } else {
                StudentLoginView(onLoginSuccess: {
                    isAuthenticated = true
                })
            }
        }
    }
}
