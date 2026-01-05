//
//  ScoreKeeperViewModel.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class ScoreKeeperViewModel {
    // MARK: - Properties
    var game: Game?
    var sortedPlayers: [PlayerScore] = []
    var isLoading = false
    var errorMessage: String?
    var showingAddPlayer = false
    var showingError = false
    
    private var modelContext: ModelContext
    private let gameId: UUID
    
    // MARK: - Computed Properties
    var team1Players: [PlayerScore] {
        sortedPlayers.filter { $0.teamNumber == 1 }
    }
    
    var team2Players: [PlayerScore] {
        sortedPlayers.filter { $0.teamNumber == 2 }
    }
    
    var team1Score: Int {
        team1Players.reduce(0) { $0 + $1.score }
    }
    
    var team2Score: Int {
        team2Players.reduce(0) { $0 + $1.score }
    }
    
    var gameTitle: String {
        guard let game = game else { return "Score Keeper" }
        return "\(game.team1.name) vs \(game.team2.name)"
    }
    
    // MARK: - Initialization
    init(gameId: UUID, modelContext: ModelContext) {
        self.gameId = gameId
        self.modelContext = modelContext
    }
    
    // MARK: - Data Loading
    func loadGame() {
        print("🔍 === LOADING GAME FOR SCOREKEEPER ===")
        print("   Looking for game ID: \(gameId)")
        
        isLoading = true
        
        do {
            // List ALL games in database for debugging
            let allGamesDescriptor = FetchDescriptor<Game>()
            let allGames = try modelContext.fetch(allGamesDescriptor)
            print("   Total games in database: \(allGames.count)")
            for game in allGames {
                print("   - Game ID: \(game.id), Teams: \(game.team1.name) vs \(game.team2.name), Status: \(game.status.rawValue)")
            }
            
            // Look for our specific game
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate<Game> { game in
                    game.id == gameId
                }
            )
            
            let fetchedGames = try modelContext.fetch(descriptor)
            print("🔍 Found \(fetchedGames.count) games with matching ID")
            
            if let fetchedGame = fetchedGames.first {
                game = fetchedGame
                print("✅ Game loaded successfully!")
                print("   Game: \(fetchedGame.team1.name) vs \(fetchedGame.team2.name)")
                print("   Status: \(fetchedGame.status.rawValue)")
                print("   Sort Order: \(fetchedGame.sortOrder.rawValue)")
                print("   Win Condition: \(fetchedGame.winCondition.rawValue)")
                print("   Player scores count: \(fetchedGame.playerScores.count)")
                
                // List ALL player scores
                for playerScore in fetchedGame.playerScores {
                    print("   👤 Player: \(playerScore.student.name), Team: \(playerScore.teamNumber), Score: \(playerScore.score)")
                }
                
                updateSortedPlayers()
            } else {
                errorMessage = "Game not found"
                showingError = true
                print("❌ Game not found with ID: \(gameId)")
                print("   Available game IDs:")
                for game in allGames {
                    print("   - \(game.id)")
                }
            }
        } catch {
            errorMessage = "Failed to load game: \(error.localizedDescription)"
            showingError = true
            print("❌ Error loading game: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Game Completion
    func completeGame() {
        guard let game = game else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            game.status = .completed
            game.timeRemaining = "0:00:00"
            
            // Update team scores with final totals
            game.team1.score = team1Score
            game.team2.score = team2Score
            
            // Save changes
            saveContext()
            
            print("✅ Game marked as completed: \(game.team1.name) vs \(game.team2.name)")
            print("   Final Score: \(team1Score) - \(team2Score)")
            
            // Determine winner based on win condition
            if let winner = game.winningTeam {
                print("   🏆 Winner: \(winner.name)")
            } else {
                print("   🤝 It's a tie!")
            }
            
            // Show success feedback
            let impact = UINotificationFeedbackGenerator()
            impact.notificationOccurred(.success)
        }
    }
    
    // MARK: - Score Management
    func incrementScore(for playerScore: PlayerScore) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            playerScore.score += 1
            updateAfterScoreChange()
        }
    }
    
    func decrementScore(for playerScore: PlayerScore) {
        guard playerScore.score > 0 else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            playerScore.score -= 1
            updateAfterScoreChange()
        }
    }
    
    func setScore(for playerScore: PlayerScore, to newScore: Int) {
        guard newScore >= 0 else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            playerScore.score = newScore
            updateAfterScoreChange()
        }
    }
    
    private func updateAfterScoreChange() {
        // Re-sort players using game's sort order
        updateSortedPlayers()
        
        // Update team totals
        game?.updateTeamScores()
        
        // Save to persistence
        saveContext()
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func updateSortedPlayers() {
        guard let game = game else { return }
        // ⭐ Use the game's sortedPlayers property which respects sort order
        sortedPlayers = game.sortedPlayers
    }
    
    // MARK: - Player Management
    func addPlayer(_ student: Student, toTeamNumber teamNumber: Int) {
        guard let game = game else { return }
        
        // Check if player already exists in game
        if game.playerScores.contains(where: { $0.student.id == student.id }) {
            errorMessage = "\(student.name) is already in this game"
            showingError = true
            return
        }
        
        let team = teamNumber == 1 ? game.team1 : game.team2
        
        let playerScore = PlayerScore(
            student: student,
            team: team,
            teamNumber: teamNumber,
            score: 0
        )
        
        game.playerScores.append(playerScore)
        modelContext.insert(playerScore)
        
        updateSortedPlayers()
        saveContext()
        
        print("✅ Added \(student.name) to Team \(teamNumber)")
    }
    
    func removePlayer(_ playerScore: PlayerScore) {
        guard let game = game else { return }
        
        withAnimation {
            game.playerScores.removeAll { $0.id == playerScore.id }
            modelContext.delete(playerScore)
            updateSortedPlayers()
            game.updateTeamScores()
            saveContext()
        }
    }
    
    // MARK: - Persistence
    private func saveContext() {
        do {
            try modelContext.save()
            print("✅ Game scores saved")
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            print("❌ Save error: \(error)")
        }
    }
}
