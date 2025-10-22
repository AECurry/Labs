//
//  ContentView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = QuizViewModel()
    
    var body: some View {
        NavigationStack {
            TitleView()
        }
        .environment(viewModel)
    }
}

#Preview {
    ContentView()
}
