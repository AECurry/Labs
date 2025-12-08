//
//  AnimationsLabApp.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

import SwiftUI
import SwiftData

/// The main entry point for the AnimationsLab application.
@main
struct AnimationsLabApp: App {
    
    /// This defines the window group that contains the app's main interface.
    /// Returns: A `Scene` containing the main app window.
    var body: some Scene {
        WindowGroup {
            
            /// `MainAppView` serves as the root container view for the application.
            /// It manages the overall layout and hosts child views.
            MainAppView()
        }
        
        /// Configures SwiftData persistence for `CountdownSession` model.
        .modelContainer(for: CountdownSession.self)
    }
}
