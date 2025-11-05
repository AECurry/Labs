//
//  EmojiDictionaryApp.swift
//  EmojiDictionary
//
//  Created by AnnElaine Curry on 10/30/25.
//

import SwiftUI

/**
 The main entry point of the EmojiDictionary application.
 
 This struct conforms to the App protocol and serves as the root of the app's
 structure. The @main attribute indicates this is the starting point when the
 app launches.
 */
@main
struct EmojiDictionaryApp: App {
    
    /**
     The main content and behavior of the app.
     
     This computed property defines the app's scene, which contains the
     primary window group and initial user interface.
     
     - Returns: A Scene that contains the app's main window and views
     */
    var body: some Scene {
        // WindowGroup is the primary scene type for apps that display
        // windows on macOS, iPadOS, and support multiple windows
        WindowGroup {
            // EmojiListView is the root view of the application
            // This is the first screen users see when launching the app
            EmojiListView()
        }
        // Note: Additional scene modifiers could be added here for:
        // - Commands (menu bar items on macOS)
        // - Window style configurations
        // - Scene-specific settings
    }
}

// MARK: - App Lifecycle Explanation
/*
 How this fits into the app lifecycle:
 
 1. When the app launches, the system looks for the @main attribute
 2. It creates an instance of EmojiDictionaryApp
 3. The body property is called to create the app's scene
 4. WindowGroup creates the main window and displays EmojiListView
 5. The app continues running until the user quits or the system terminates it
 
 Additional capabilities that could be added to this file:
 
 - State restoration
 - Handoff continuation activities
 - Universal link handling
 - Custom scene types for multiple window support
 */

// MARK: - Platform Considerations
/*
 This app structure works across all Apple platforms:
 
 - iOS: Single full-screen window
 - iPadOS: Supports multiple windows and split screen
 - macOS: Creates a resizable window
 - watchOS: Uses a different scene type (WindowGroup adapts accordingly)
 */

#Preview("App Preview") {
    // While we can't preview the entire @main app directly,
    // we can preview the main content view
    EmojiListView()
}
