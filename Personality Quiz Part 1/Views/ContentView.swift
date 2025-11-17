//
//  ContentView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

/**
 MAIN APPLICATION ENTRY POINT FOR ENTIRE APP
 ============================
 Why this file exists: Provides the foundational structure that hosts all other quiz screens, and sets up the core architecture and state management for the entire application
 */

struct ContentView: View {
    // STATE MANAGEMENT
    //Creates and maintains the single source of truth for quiz data. Ensures all child views have access to the same quiz state and can react to changes
    //Benefit: When quiz progresses or answers change, all views update automatically
    @State private var viewModel = QuizViewModel()
    
    // Main View Body
    var body: some View {
        
        // Allows moving between title screen → questions → results. Essential for multi-screen quiz flow without manual view management
        NavigationStack {
            TitleView() // The inital screen users see when they open the app
        }
        
       
        //.environment injects the view model into the view hierarchy. This allows any child view to access quiz data without passing through multiple layers.
        .environment(viewModel)
    }
}

#Preview {
    ContentView()
}
