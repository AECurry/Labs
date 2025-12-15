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
    // ═══════════════════════════════════════════════════════════
    // PROPERTIES
    // ═══════════════════════════════════════════════════════════
    
    var gameSetup = GameSetup()
    var availableStudents: [Student] = Student.sampleRoster
    var errorMessage: String?
    var showError: Bool = false
    
    private var modelContext: ModelContext
    
    // ═══════════════════════════════════════════════════════════
    // INITIALIZATION
    // ═══════════════════════════════════════════════════════════
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        setupDefaultTeams()
    }
    
    // ═══════════════════════════════════════════════════════════
    // SETUP
    // ═══════════════════════════════════════════════════════════
    
    private func setupDefaultTeams() {
        // Initialize with empty teams
        gameSetup.team1 = TeamSetup(name: "", colorChoice: .fnBlue)
        gameSetup.team2 = TeamSetup(name: "", colorChoice: .fnRed)
    }
    
    // ═══════════════════════════════════════════════════════════
    // TEAM MANAGEMENT
    // ═══════════════════════════════════════════════════════════
    
    func addStudentToTeam(_ student: Student, teamNumber: Int) {
        if teamNumber == 1 {
            gameSetup.team1?.selectedStudents.append(student)
        } else {
            gameSetup.team2?.selectedStudents.append(student)
        }
    }
    
    func removeStudentFromTeam(_ student: Student, teamNumber: Int) {
        if teamNumber == 1 {
            gameSetup.team1?.selectedStudents.removeAll { $0.id == student.id }
        } else {
            gameSetup.team2?.selectedStudents.removeAll { $0.id == student.id }
        }
    }
    
    func isStudentSelected(_ student: Student) -> Bool {
        let inTeam1 = gameSetup.team1?.selectedStudents.contains(where: { $0.id == student.id }) ?? false
        let inTeam2 = gameSetup.team2?.selectedStudents.contains(where: { $0.id == student.id }) ?? false
        return inTeam1 || inTeam2
    }
    
    func getTeamNumber(for student: Student) -> Int? {
        if gameSetup.team1?.selectedStudents.contains(where: { $0.id == student.id }) == true {
            return 1
        }
        if gameSetup.team2?.selectedStudents.contains(where: { $0.id == student.id }) == true {
            return 2
        }
        return nil
    }
    
    // ═══════════════════════════════════════════════════════════
    // VALIDATION
    // ═══════════════════════════════════════════════════════════
    
    func validateAndSave() -> Bool {
        // Check if game setup is valid
        guard gameSetup.isValid else {
            errorMessage = "Please complete all fields and select players for both teams"
            showError = true
            return false
        }
        
        // Check player count matches
        guard let team1 = gameSetup.team1, let team2 = gameSetup.team2 else {
            errorMessage = "Teams not properly configured"
            showError = true
            return false
        }
        
        let requiredCount = gameSetup.playerCount.playerNumber
        if team1.selectedStudents.count != requiredCount {
            errorMessage = "Team 1 needs \(requiredCount) player(s)"
            showError = true
            return false
        }
        
        if team2.selectedStudents.count != requiredCount {
            errorMessage = "Team 2 needs \(requiredCount) player(s)"
            showError = true
            return false
        }
        
        // All valid - proceed to save
        return saveGame()
    }
    
    // ═══════════════════════════════════════════════════════════
    // SAVE TO SWIFTDATA
    // ═══════════════════════════════════════════════════════════
    
    private func saveGame() -> Bool {
        guard let team1Setup = gameSetup.team1,
              let team2Setup = gameSetup.team2 else {
            return false
        }
        
        // Create Team models from TeamSetup
        let team1 = Team(
            name: team1Setup.name,
            score: 0,
            colorAssetName: colorToAssetName(team1Setup.colorChoice)
        )
        
        let team2 = Team(
            name: team2Setup.name,
            score: 0,
            colorAssetName: colorToAssetName(team2Setup.colorChoice)
        )
        
        // Determine game status based on scheduling
        let status: Game.GameStatus = gameSetup.isScheduled ? .upcoming : .live
        
        // Calculate time remaining
        let timeRemaining: String
        if gameSetup.isScheduled {
            timeRemaining = gameSetup.timeUntilStart
        } else {
            timeRemaining = "0:15:00" // Default 15 minutes for live game
        }
        
        // Create Game model
        let game = Game(
            date: gameSetup.scheduledTime,
            timeRemaining: timeRemaining,
            status: status,
            team1: team1,
            team2: team2,
            gameMode: gameSetup.gameMode
        )
        
        // Insert into SwiftData
        modelContext.insert(game)
        
        // Save context
        do {
            try modelContext.save()
            print("✅ Game created successfully")
            return true
        } catch {
            errorMessage = "Failed to save game: \(error.localizedDescription)"
            showError = true
            print("❌ Save error: \(error)")
            return false
        }
    }
    
    // ═══════════════════════════════════════════════════════════
    // HELPERS
    // ═══════════════════════════════════════════════════════════
    
    private func colorToAssetName(_ color: Color) -> String {
        // Map Color to asset name (expand as needed)
        switch color {
        case .fnBlue: return "FortniteBlue"
        case .fnRed: return "FortniteRed"
        case .fnGreen: return "FortniteGreen"
        case .fnPurple: return "FortnitePurple"
        case .fnGold: return "FortniteGold"
        default: return "FortniteBlue"
        }
    }
    
    func reset() {
        gameSetup = GameSetup()
        setupDefaultTeams()
        errorMessage = nil
        showError = false
    }
}
