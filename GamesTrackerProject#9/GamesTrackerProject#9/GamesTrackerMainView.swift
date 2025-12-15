//
//  GamesTrackerMainView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/10/25.
//

import SwiftUI
import SwiftData

struct GamesTrackerMainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
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
                        TeamsView()
                    case 3:
                        RankingView()
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
    }
}

// MARK: - Placeholder Views (NO backgrounds - inherit from parent)

struct PlayersView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Players View")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text("Coming Soon")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 8)
            
            Spacer()
        }
    }
}

struct TeamsView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Teams View")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text("Coming Soon")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 8)
            
            Spacer()
        }
    }
}

struct RankingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Ranking View")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text("Coming Soon")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 8)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    let container = try! ModelContainer(
        for: Game.self, Team.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    return GamesTrackerMainView()
        .modelContainer(container)
}
