//
//  TournamentCardModels.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI
import SwiftData

// Display models (for UI only - NOT SwiftData)
struct TournamentMatchup: Identifiable {
    var id: UUID
    var team1: TeamDisplay  // This should be TeamDisplay
    var team2: TeamDisplay  // This should be TeamDisplay
    var timeRemaining: String
    var status: Game.GameStatus
    
    // Convert from SwiftData Game model
    init(from game: Game) {
        self.id = game.id
        self.team1 = TeamDisplay(from: game.team1)
        self.team2 = TeamDisplay(from: game.team2)
        self.timeRemaining = game.timeRemaining
        self.status = game.status
    }
    
    // Regular init for sample data
    init(id: UUID = UUID(), team1: TeamDisplay, team2: TeamDisplay, timeRemaining: String, status: Game.GameStatus) {
        self.id = id
        self.team1 = team1
        self.team2 = team2
        self.timeRemaining = timeRemaining
        self.status = status
    }
}

struct TeamDisplay: Identifiable {
    var id: UUID
    var name: String
    var score: Int
    var logoColor: Color
    var isWinning: Bool = false
    
    init(from team: Team) {  // Takes SwiftData Team
        self.id = team.id
        self.name = team.name
        self.score = team.score
        self.logoColor = team.logoColor
        self.isWinning = false
    }
    
    // Regular init for sample data
    init(id: UUID = UUID(), name: String, score: Int, logoColor: Color, isWinning: Bool = false) {
        self.id = id
        self.name = name
        self.score = score
        self.logoColor = logoColor
        self.isWinning = isWinning
    }
}
