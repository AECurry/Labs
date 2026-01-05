//
//  GamesTrackerMainView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/10/25.
//

// Main Parent View for the whole app should be kept dumb
import SwiftUI
import SwiftData

struct GamesTrackerMainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background - ALWAYS visible behind everything
                AnimatedGridBackground()
                    .ignoresSafeArea()
                
                // Content layer
                VStack(spacing: 0) {
                    // Main content area
                    Group {
                        switch selectedTab {
                        case 0:
                            TournamentView()
                        case 1:
                            PlayersView()
                        case 2:
                            RankingView() // This will now reference the extracted view
                        default:
                            TournamentView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Navigation bar at bottom
                    BottomNavigationBar(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Preview
#Preview {
    let container = try! ModelContainer(
        for: Game.self, Team.self, Student.self, PlayerScore.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    return GamesTrackerMainView()
        .modelContainer(container)
}
