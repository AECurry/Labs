//
//  isoWalkApp.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//

import SwiftUI

@main
struct isoWalkApp: App {
    // 1. Initialize the Single Source of Truth for the Session
    // We use @State here so the object lives for the entire app lifecycle
    @State private var sessionManager = SessionManager()
    
    // 2. Link to the User's Dark Mode preference
    // This listens to the toggle you created in LayoutCustomizationView
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            isoWalkMainView()
                // 3. Inject the SessionManager into the environment
                // This makes it available to every view in the app
                .environment(sessionManager)
                
                // 4. Force the color scheme globally based on settings
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

