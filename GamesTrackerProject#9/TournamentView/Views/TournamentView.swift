//
//  TournamentView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI
import SwiftData

struct TournamentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: TournamentViewModel?
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                TitleAndSegmentedView(
                    viewModel: viewModel,
                    modelContext: modelContext
                )
            } else {
                VStack {
                    ProgressView("Loading...")
                        .foregroundColor(.fnWhite)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    print("🔍 TournamentView - Creating ViewModel")
                    viewModel = TournamentViewModel(modelContext: modelContext)
                }
            }
        }
        // CRITICAL: Completely transparent
        .background(Color.clear)
        .onAppear {
            print("🔍 TournamentView appeared")
        }
    }
}

#Preview {
    ZStack {
        Color.purple.ignoresSafeArea() // Test background
        TournamentView()
    }
    .modelContainer(for: [Game.self, Team.self], inMemory: true)
}
