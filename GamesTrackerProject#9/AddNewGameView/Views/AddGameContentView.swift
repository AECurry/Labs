//
//  AddGameContentView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//
//


//Main content layout for game creation

import SwiftUI
import SwiftData

struct AddGameContentView: View {
    @Bindable var viewModel: AddGameViewModel
    let allStudents: [Student]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.0, blue: 0.15)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    GameModePickerView(selectedMode: $viewModel.gameMode)
                    
                    PlayerCountPickerView(
                        selectedCount: $viewModel.playerCount,
                        onCountChange: viewModel.handlePlayerCountChange
                    )
                    
                    TeamConfigurationView(
                        teamNumber: 1,
                        teamName: $viewModel.team1Name,
                        teamColor: $viewModel.team1Color,
                        selectedPlayers: $viewModel.team1Players,
                        showSelection: $viewModel.showingTeam1Selection,
                        requiredPlayerCount: viewModel.playerCount.playerNumber,
                        onRemovePlayer: viewModel.removeTeam1Player
                    )
                    
                    TeamConfigurationView(
                        teamNumber: 2,
                        teamName: $viewModel.team2Name,
                        teamColor: $viewModel.team2Color,
                        selectedPlayers: $viewModel.team2Players,
                        showSelection: $viewModel.showingTeam2Selection,
                        requiredPlayerCount: viewModel.playerCount.playerNumber,
                        onRemovePlayer: viewModel.removeTeam2Player
                    )
                    
                    // ⭐ NEW: Scoring Rules Section (replaces static text)
                    ScoringRulesSection(
                        sortOrder: $viewModel.sortOrder,
                        winCondition: $viewModel.winCondition
                    )
                    
                    TimePickerView(
                        isScheduled: $viewModel.isScheduled,
                        scheduledTime: $viewModel.scheduledTime
                    )
                    
                    // Create Game Button
                    CreateGameButton(
                        isEnabled: viewModel.canCreateGame,
                        isSaving: viewModel.isSaving,
                        action: {
                            // Call createGame and dismiss if successful
                            if viewModel.createGame() {
                                dismiss()
                            }
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .sheet(isPresented: $viewModel.showingTeam1Selection) {
            SelectPlayersSheet(
                title: "Team 1 Players",
                selectedPlayers: $viewModel.team1Players,
                teamNumber: 1,
                requiredCount: viewModel.playerCount.playerNumber,
                availableStudents: allStudents
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.showingTeam2Selection) {
            SelectPlayersSheet(
                title: "Team 2 Players",
                selectedPlayers: $viewModel.team2Players,
                teamNumber: 2,
                requiredCount: viewModel.playerCount.playerNumber,
                availableStudents: allStudents
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// Create Game Button Component
struct CreateGameButton: View {
    let isEnabled: Bool
    let isSaving: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if isSaving {
                HStack {
                    ProgressView()
                        .tint(.fnWhite)
                        .scaleEffect(0.8)
                    Text("Creating...")
                        .foregroundColor(.fnWhite)
                }
            } else {
                Text("Create Game")
                    .foregroundColor(.fnWhite)
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(isEnabled ? Color.fnBlue : Color.fnGray1)
        .cornerRadius(12)
        .disabled(!isEnabled || isSaving)
        .padding(.top, 12)
    }
}
