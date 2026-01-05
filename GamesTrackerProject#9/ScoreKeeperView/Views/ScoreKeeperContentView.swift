//
//  ScoreKeeperContentView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

import SwiftUI

struct ScoreKeeperContentView: View {
    @Bindable var viewModel: ScoreKeeperViewModel
    let dismiss: DismissAction
    
    // ⭐ Namespace for player row animations
    @Namespace private var playerAnimation
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Team Scores Header with Complete Game button
                TeamScoresHeader(viewModel: viewModel, dismiss: dismiss)
                
                // Players List with matchedGeometryEffect
                PlayersSection(viewModel: viewModel, namespace: playerAnimation)
            }
            .padding()
        }
    }
}

// MARK: - Team Scores Header Component (unchanged)
struct TeamScoresHeader: View {
    @Bindable var viewModel: ScoreKeeperViewModel
    let dismiss: DismissAction
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 40) {
                // Team 1
                VStack(spacing: 12) {
                    Text(viewModel.game?.team1.name ?? "Team 1")
                        .font(.headline)
                        .foregroundColor(.fnWhite)
                    
                    Text("\(viewModel.team1Score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(viewModel.game?.team1.logoColor ?? .fnBlue)
                }
                
                Text("VS")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.fnGray1)
                
                // Team 2
                VStack(spacing: 12) {
                    Text(viewModel.game?.team2.name ?? "Team 2")
                        .font(.headline)
                        .foregroundColor(.fnWhite)
                    
                    Text("\(viewModel.team2Score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(viewModel.game?.team2.logoColor ?? .fnRed)
                }
            }
            .padding()
            .background(Color.fnBlack.opacity(0.3))
            .cornerRadius(16)
            
            // Complete Game Button (only show for live games)
            if viewModel.game?.status == .live {
                Button {
                    viewModel.completeGame()
                    // Navigate back after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "flag.checkered")
                        Text("Complete Game")
                    }
                    .font(.headline)
                    .foregroundColor(.fnWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.fnGreen)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Players Section Component WITH MATCHED GEOMETRY
struct PlayersSection: View {
    @Bindable var viewModel: ScoreKeeperViewModel
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 24) {
            if viewModel.sortedPlayers.isEmpty {
                ScoreKeeperEmptyView()
            } else {
                // Team 1 Section
                if !viewModel.team1Players.isEmpty {
                    TeamPlayersSection(
                        teamNumber: 1,
                        teamName: viewModel.game?.team1.name ?? "Team 1",
                        teamColor: viewModel.game?.team1.logoColor ?? .fnBlue,
                        players: viewModel.team1Players,
                        viewModel: viewModel,
                        namespace: namespace
                    )
                }
                
                // Team 2 Section
                if !viewModel.team2Players.isEmpty {
                    TeamPlayersSection(
                        teamNumber: 2,
                        teamName: viewModel.game?.team2.name ?? "Team 2",
                        teamColor: viewModel.game?.team2.logoColor ?? .fnRed,
                        players: viewModel.team2Players,
                        viewModel: viewModel,
                        namespace: namespace
                    )
                }
            }
        }
    }
}

// MARK: - Team Players Section Component WITH ANIMATION (FIXED - NO DUPLICATE SCORE)
struct TeamPlayersSection: View {
    let teamNumber: Int
    let teamName: String
    let teamColor: Color
    let players: [PlayerScore]
    @Bindable var viewModel: ScoreKeeperViewModel
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // ⭐ FIXED: Team Header WITHOUT score (score is already shown at top)
            HStack {
                Circle()
                    .fill(teamColor)
                    .frame(width: 12, height: 12)
                
                Text("Team \(teamNumber) - \(teamName)")
                    .font(.headline)
                    .foregroundColor(.fnWhite)
                
                Spacer()
                
                // ⭐ REMOVED: Duplicate score display
                // The score is already prominently displayed at the top of the screen
            }
            .padding(.horizontal, 4)
            
            // Team Players WITH matchedGeometryEffect
            ForEach(players) { playerScore in
                PlayerScoreRow(
                    playerScore: playerScore,
                    onIncrement: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            viewModel.incrementScore(for: playerScore)
                        }
                    },
                    onDecrement: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            viewModel.decrementScore(for: playerScore)
                        }
                    }
                )
                .matchedGeometryEffect(
                    id: playerScore.id,
                    in: namespace
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
    }
}

// MARK: - Supporting Views

struct ScoreKeeperEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 60))
                .foregroundColor(.fnGray1)
            
            Text("No Players Yet")
                .font(.title2)
                .foregroundColor(.fnWhite)
            
            Text("Tap + to add players to the game")
                .font(.body)
                .foregroundColor(.fnGray1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

struct ScoreKeeperLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.fnWhite)
            Text("Loading game...")
                .foregroundColor(.fnWhite)
                .padding(.top)
        }
    }
}

struct ScoreKeeperErrorView: View {
    let errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.fnRed)
            
            Text("Game Not Found")
                .font(.title2)
                .foregroundColor(.fnWhite)
            
            Text(errorMessage ?? "Unable to load game")
                .font(.body)
                .foregroundColor(.fnGray1)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
