//
//  AddGameViewModel.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class AddGameViewModel {
    // MARK: - Properties
    
    // Game configuration
    var gameMode: GameMode = .battleRoyale
    var playerCount: PlayerCount = .duo
    
    // ⭐ NEW: Scoring rules
    var sortOrder: SortOrder = .highestToLowest
    var winCondition: WinCondition = .highestScore
    
    // Team 1 - EMPTY by default
    var team1Name = ""
    var team1Color: Color = .fnBlue
    var team1Players: [Student] = []
    
    // Team 2 - EMPTY by default
    var team2Name = ""
    var team2Color: Color = .fnRed
    var team2Players: [Student] = []
    
    // Scheduling
    var isScheduled = true
    var scheduledTime = Date().addingTimeInterval(3600)
    
    // UI State
    var showingError = false
    var errorMessage = ""
    var showingTeam1Selection = false
    var showingTeam2Selection = false
    var isSaving = false
    
    // Students
    var availableStudents: [Student] = []
    var isLoading = false
    
    private var modelContext: ModelContext
    
    // MARK: - Initialization
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadAvailableStudents()
    }
    
    private func loadAvailableStudents() {
        isLoading = true
        
        do {
            let descriptor = FetchDescriptor<Student>(
                sortBy: [SortDescriptor(\.name)]
            )
            availableStudents = try modelContext.fetch(descriptor)
            print("✅ Loaded \(availableStudents.count) students for game creation")
        } catch {
            errorMessage = "Failed to load students: \(error.localizedDescription)"
            showingError = true
            print("❌ Error loading students: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Computed Properties
    
    var canCreateGame: Bool {
        !team1Name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !team2Name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        team1Players.count == playerCount.playerNumber &&
        team2Players.count == playerCount.playerNumber &&
        Set(team1Players.map { $0.id }).intersection(Set(team2Players.map { $0.id })).isEmpty
    }
    
    // MARK: - Team Management
    
    func removeTeam1Player(_ player: Student) {
        team1Players.removeAll { $0.id == player.id }
    }
    
    func removeTeam2Player(_ player: Student) {
        team2Players.removeAll { $0.id == player.id }
    }
    
    func handlePlayerCountChange(_ newCount: PlayerCount) {
        if team1Players.count > newCount.playerNumber {
            team1Players = Array(team1Players.prefix(newCount.playerNumber))
        }
        if team2Players.count > newCount.playerNumber {
            team2Players = Array(team2Players.prefix(newCount.playerNumber))
        }
    }
    
    // MARK: - Game Creation (Returns Bool for success)
    
    func createGame() -> Bool {
        guard canCreateGame else {
            errorMessage = "Please complete all fields correctly"
            showingError = true
            print("❌ Cannot create game - validation failed")
            return false
        }
        
        print("🎮 === STARTING GAME CREATION ===")
        print("   Team 1: \(team1Name) - Players: \(team1Players.map { $0.name })")
        print("   Team 2: \(team2Name) - Players: \(team2Players.map { $0.name })")
        
        isSaving = true
        
        do {
            // Create teams
            let team1 = Team(
                name: team1Name.trimmingCharacters(in: .whitespacesAndNewlines),
                score: 0,
                colorAssetName: colorToAssetName(team1Color)
            )
            
            let team2 = Team(
                name: team2Name.trimmingCharacters(in: .whitespacesAndNewlines),
                score: 0,
                colorAssetName: colorToAssetName(team2Color)
            )
            
            // Insert teams first
            modelContext.insert(team1)
            modelContext.insert(team2)
            
            let status: Game.GameStatus = isScheduled ? .upcoming : .live
            let timeRemaining = calculateTimeRemaining()
            
            // Create the game with scoring rules
            let game = Game(
                date: scheduledTime,
                timeRemaining: timeRemaining,
                status: status,
                team1: team1,
                team2: team2,
                gameMode: gameMode,
                sortOrder: sortOrder,
                winCondition: winCondition
            )
            
            // Insert the game
            modelContext.insert(game)
            
            // Add players to game
            addPlayersToGame(game, team1: team1, team2: team2)
            
            // Save everything
            try modelContext.save()
            
            // Force context refresh
            modelContext.autosaveEnabled = true
            
            print("✅ === GAME CREATION SUCCESSFUL ===")
            print("   Game ID: \(game.id)")
            print("   Total PlayerScores in Game: \(game.playerScores.count)")
            
            // Verify each player score
            for playerScore in game.playerScores {
                print("   - Player: \(playerScore.student.name), Team: \(playerScore.teamNumber)")
            }
            
            // Verify the game exists in database
            verifyGameInDatabase(game.id)
            
            updateStudentLastPlayed(team1Players + team2Players)
            isSaving = false
            
            return true
            
        } catch {
            print("❌ === GAME CREATION FAILED ===")
            print("   Error: \(error)")
            errorMessage = "Failed to save game: \(error.localizedDescription)"
            showingError = true
            isSaving = false
            return false
        }
    }
    
    // MARK: - Player Score Management
    
    private func addPlayersToGame(_ game: Game, team1: Team, team2: Team) {
        print("🎮 Adding players to game...")
        print("   Team 1 players: \(team1Players.count)")
        print("   Team 2 players: \(team2Players.count)")
        
        // Add Team 1 players
        for student in team1Players {
            let playerScore = PlayerScore(
                student: student,
                team: team1,
                teamNumber: 1,
                score: 0
            )
            
            // Set bidirectional relationship
            playerScore.game = game
            game.playerScores.append(playerScore)
            
            // Insert into context
            modelContext.insert(playerScore)
            
            print("   ✅ Added \(student.name) to Team 1")
        }
        
        // Add Team 2 players
        for student in team2Players {
            let playerScore = PlayerScore(
                student: student,
                team: team2,
                teamNumber: 2,
                score: 0
            )
            
            // Set bidirectional relationship
            playerScore.game = game
            game.playerScores.append(playerScore)
            
            // Insert into context
            modelContext.insert(playerScore)
            
            print("   ✅ Added \(student.name) to Team 2")
        }
        
        print("📊 Total players added to game: \(game.playerScores.count)")
    }
    
    // MARK: - Debug Helper
    
    private func verifyGameInDatabase(_ gameId: UUID) {
        do {
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate<Game> { $0.id == gameId }
            )
            let fetchedGames = try modelContext.fetch(descriptor)
            print("🔍 Verifying game in database...")
            print("   Found \(fetchedGames.count) game(s) with ID: \(gameId)")
            
            if let fetchedGame = fetchedGames.first {
                print("   ✅ Game found: \(fetchedGame.team1.name) vs \(fetchedGame.team2.name)")
                print("   📊 Player scores count: \(fetchedGame.playerScores.count)")
                
                for playerScore in fetchedGame.playerScores {
                    print("   👤 - \(playerScore.student.name) (Team \(playerScore.teamNumber))")
                }
            }
        } catch {
            print("❌ Failed to verify game: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateStudentLastPlayed(_ students: [Student]) {
        let now = Date()
        for student in students {
            student.lastPlayed = now
        }
        
        do {
            try modelContext.save()
            print("✅ Updated last played for \(students.count) students")
        } catch {
            print("⚠️ Failed to update student last played: \(error)")
        }
    }
    
    private func calculateTimeRemaining() -> String {
        if !isScheduled { return "0:15:00" }
        
        let interval = scheduledTime.timeIntervalSinceNow
        if interval <= 0 { return "0:00:00" }
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func colorToAssetName(_ color: Color) -> String {
        if color == .fnBlue { return "FortniteBlue" }
        if color == .fnRed { return "FortniteRed" }
        if color == .fnGreen { return "FortniteGreen" }
        if color == .fnPurple { return "FortnitePurple" }
        if color == .fnGold { return "FortniteGold" }
        return "FortniteBlue"
    }
}
