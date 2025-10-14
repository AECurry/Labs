//
//  ContentView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var quizManager = QuizScreensManager()
    
    var body: some View {
        NavigationStack {
            TitleView()
                .environment(quizManager) // Inject here too for safety
        }
        .environment(quizManager)
    }
}

#Preview {
    ContentView()
}
