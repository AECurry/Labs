//
//  TournamentMatch.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI

// MARK: - TournamentMatch Display Model
/// Display model for UI - created from SwiftData Game models
struct TournamentMatch: Identifiable {
    let id: UUID
    var team1Name: String
    var team1Score: Int
    var team1Initials: String
    var team1Color: Color
    
    var team2Name: String
    var team2Score: Int
    var team2Initials: String
    var team2Color: Color
    
    var timeRemaining: String
    var isLive: Bool
    var matchNumber: Int
    var gameMode: GameMode
    
    // ✅ CRITICAL: Store the actual game status
    var status: Game.GameStatus
    
    // MARK: - Initializer from Game Model
    init(game: Game) {
        self.id = game.id
        self.team1Name = game.team1.name
        self.team1Score = game.team1.score
        self.team1Initials = String(game.team1.name.prefix(2)).uppercased()
        self.team1Color = game.team1.logoColor
        
        self.team2Name = game.team2.name
        self.team2Score = game.team2.score
        self.team2Initials = String(game.team2.name.prefix(2)).uppercased()
        self.team2Color = game.team2.logoColor
        
        self.timeRemaining = game.timeRemaining
        self.isLive = (game.status == .live)
        self.matchNumber = 0
        self.gameMode = game.gameModeEnum
        
        // ✅ CRITICAL: Store the actual status
        self.status = game.status
    }
    
    // MARK: - Convenience Initializer (For Previews Only)
    init(
        team1Name: String,
        team1Score: Int = 0,
        team1Initials: String? = nil,
        team1Color: Color = .fnBlue,
        team2Name: String,
        team2Score: Int = 0,
        team2Initials: String? = nil,
        team2Color: Color = .fnRed,
        timeRemaining: String = "0:00:00",
        isLive: Bool = false,
        matchNumber: Int = 0,
        gameMode: GameMode = .battleRoyale,
        status: Game.GameStatus = .upcoming
    ) {
        self.id = UUID()
        self.team1Name = team1Name
        self.team1Score = team1Score
        self.team1Initials = team1Initials ?? String(team1Name.prefix(2).uppercased())
        self.team1Color = team1Color
        
        self.team2Name = team2Name
        self.team2Score = team2Score
        self.team2Initials = team2Initials ?? String(team2Name.prefix(2).uppercased())
        self.team2Color = team2Color
        
        self.timeRemaining = timeRemaining
        self.isLive = isLive
        self.matchNumber = matchNumber
        self.gameMode = gameMode
        self.status = status
    }
    
    // MARK: - Computed Properties
    var hasScores: Bool {
        return team1Score > 0 || team2Score > 0
    }
    
    var statusDisplay: String {
        switch status {
        case .live: return "🔥 LIVE"
        case .upcoming: return "⏰ UPCOMING"
        case .completed: return "✅ COMPLETED"
        case .postponed: return "⏸️ POSTPONED"
        }
    }
}

// MARK: - GameMode Enum
enum GameMode: String, CaseIterable {
    case battleRoyale = "Battle Royale"
    case zeroBuild = "Zero Build"
    case creative = "Creative"
    case tournament = "Tournament"
    
    var iconName: String {
        switch self {
        case .battleRoyale: return "flag.fill"
        case .zeroBuild: return "xmark.rectangle.fill"
        case .creative: return "paintbrush.fill"
        case .tournament: return "trophy.fill"
        }
    }
}

// MARK: - Sample Data (For Previews Only)
extension TournamentMatch {
    static var sampleTournament: [TournamentMatch] {
        return [
            TournamentMatch(
                team1Name: "Shadow Ninjas",
                team1Score: 22,
                team1Initials: "SN",
                team1Color: .fnPurple,
                team2Name: "Golden Eagles",
                team2Score: 20,
                team2Initials: "GE",
                team2Color: .fnGold,
                timeRemaining: "0:03:12",
                isLive: true,
                matchNumber: 1,
                gameMode: .battleRoyale,
                status: .live
            ),
            TournamentMatch(
                team1Name: "Alpha Team",
                team1Score: 0,
                team1Initials: "AT",
                team1Color: .fnRed,
                team2Name: "Omega Team",
                team2Score: 0,
                team2Initials: "OT",
                team2Color: .fnBlue,
                timeRemaining: "1:30:00",
                isLive: false,
                matchNumber: 2,
                gameMode: .zeroBuild,
                status: .upcoming
            ),
            TournamentMatch(
                team1Name: "Fire Dragons",
                team1Score: 25,
                team1Initials: "FD",
                team1Color: .fnRed,
                team2Name: "Ice Phoenix",
                team2Score: 18,
                team2Initials: "IP",
                team2Color: .fnBlue,
                timeRemaining: "0:00:00",
                isLive: false,
                matchNumber: 3,
                gameMode: .tournament,
                status: .completed
            )
        ]
    }
}
