//
//  ScoreKeeperView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

// Main Parent View for ScoreKeeperView folder should be kept dumb

import SwiftUI
import SwiftData

struct ScoreKeeperView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ScoreKeeperViewModel?
    
    let gameId: UUID
    
    var body: some View {
        ZStack {
            // Background
            AnimatedGridBackground()
                .ignoresSafeArea()
            
            // Content
            Group {
                if let viewModel = viewModel {
                    if viewModel.isLoading {
                        ScoreKeeperLoadingView()  // CHANGED
                    } else if viewModel.game == nil {
                        ScoreKeeperErrorView(errorMessage: viewModel.errorMessage)  // CHANGED
                    } else {
                        ScoreKeeperContentView(viewModel: viewModel, dismiss: dismiss)
                    }
                } else {
                    ScoreKeeperLoadingView()  // CHANGED
                }
            }
            
            .navigationTitle(viewModel?.gameTitle ?? "Score Keeper")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel == nil {
                    viewModel = ScoreKeeperViewModel(gameId: gameId, modelContext: modelContext)
                    viewModel?.loadGame()
                }
            }
            .sheet(isPresented: Binding(
                get: { viewModel?.showingAddPlayer ?? false },
                set: { viewModel?.showingAddPlayer = $0 }
            )) {
                if let viewModel = viewModel, let game = viewModel.game {
                    AddPlayerToGameSheet(
                        game: game,
                        onAddPlayer: { student, teamNumber in
                            viewModel.addPlayer(student, toTeamNumber: teamNumber)
                        }
                    )
                }
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel?.showingError ?? false },
                set: { viewModel?.showingError = $0 }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel?.errorMessage ?? "An error occurred")
            }
        }
    }
}
    
    // MARK: - Preview
    /*
    #Preview {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: Game.self, Team.self, Student.self, PlayerScore.self,
            configurations: config
        )
        
        let context = container.mainContext
        
        // Create sample data
        let team1 = Team(name: "Team Alpha", colorAssetName: "FortniteBlue")
        let team2 = Team(name: "Team Bravo", colorAssetName: "FortniteRed")
        
        let game = Game(
            date: Date(),
            timeRemaining: "0:15:00",
            status: .live,
            team1: team1,
            team2: team2,
            gameMode: .battleRoyale
        )
        
        context.insert(team1)
        context.insert(team2)
        context.insert(game)
        
        let student1 = Student(name: "Alex Johnson", grade: 11, skillLevel: .pro)
        let student2 = Student(name: "Jordan Lee", grade: 10, skillLevel: .advanced)
        
        context.insert(student1)
        context.insert(student2)
        
        let ps1 = PlayerScore(student: student1, team: team1, teamNumber: 1, score: 15)
        let ps2 = PlayerScore(student: student2, team: team2, teamNumber: 2, score: 12)
        
        game.playerScores = [ps1, ps2]
        context.insert(ps1)
        context.insert(ps2)
        
        try? context.save()
        
        return NavigationStack {
            ScoreKeeperView(gameId: game.id)
                .modelContainer(container)
        }
    }
}
*/
