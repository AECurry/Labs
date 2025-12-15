//
//  TournamentMatch.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI

/// Display model for tournament matches - used for UI rendering
/// Separate from SwiftData models to keep UI concerns separate from persistence
struct TournamentMatch: Identifiable {
    let id: UUID
    var team1Name: String
    var team1Score: Int
    var team1Image: String?
    var team1Initials: String
    var team1Color: Color
    
    var team2Name: String
    var team2Score: Int
    var team2Image: String?
    var team2Initials: String
    var team2Color: Color
    
    var timeRemaining: String
    var isLive: Bool
    var matchNumber: Int
    var gameMode: GameMode
    
    // MARK: - Initializer
    init(
        id: UUID,
        team1Name: String,
        team1Score: Int = 0,
        team1Image: String? = nil,
        team1Initials: String? = nil,
        team1Color: Color = .fnBlue,
        team2Name: String,
        team2Score: Int = 0,
        team2Image: String? = nil,
        team2Initials: String? = nil,
        team2Color: Color = .fnRed,
        timeRemaining: String = "0:00:00",
        isLive: Bool = false,
        matchNumber: Int = 0,
        gameMode: GameMode = .battleRoyale
    ) {
        self.id = id
        self.team1Name = team1Name
        self.team1Score = team1Score
        self.team1Image = team1Image
        self.team1Initials = team1Initials ?? String(team1Name.prefix(2).uppercased())
        self.team1Color = team1Color
        
        self.team2Name = team2Name
        self.team2Score = team2Score
        self.team2Image = team2Image
        self.team2Initials = team2Initials ?? String(team2Name.prefix(2).uppercased())
        self.team2Color = team2Color
        
        self.timeRemaining = timeRemaining
        self.isLive = isLive
        self.matchNumber = matchNumber
        self.gameMode = gameMode
    }
    
    // Convenience initializer for samples
    init(
        team1Name: String,
        team1Score: Int = 0,
        team1Image: String? = nil,
        team1Initials: String? = nil,
        team1Color: Color = .fnBlue,
        team2Name: String,
        team2Score: Int = 0,
        team2Image: String? = nil,
        team2Initials: String? = nil,
        team2Color: Color = .fnRed,
        timeRemaining: String = "0:00:00",
        isLive: Bool = false,
        matchNumber: Int = 0,
        gameMode: GameMode = .battleRoyale
    ) {
        self.init(
            id: UUID(),
            team1Name: team1Name,
            team1Score: team1Score,
            team1Image: team1Image,
            team1Initials: team1Initials,
            team1Color: team1Color,
            team2Name: team2Name,
            team2Score: team2Score,
            team2Image: team2Image,
            team2Initials: team2Initials,
            team2Color: team2Color,
            timeRemaining: timeRemaining,
            isLive: isLive,
            matchNumber: matchNumber,
            gameMode: gameMode
        )
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

// MARK: - Sample Data
extension TournamentMatch {
    static var sampleTournament: [TournamentMatch] {
        return [
            TournamentMatch(
                team1Name: "Team A",
                team1Score: 10,
                team1Color: .fnBlue,
                team2Name: "Team B",
                team2Score: 8,
                team2Color: .fnRed,
                timeRemaining: "01:30:00",
                isLive: true,
                matchNumber: 1,
                gameMode: .battleRoyale
            ),
            TournamentMatch(
                team1Name: "Team C",
                team1Score: 15,
                team1Color: .fnGreen,
                team2Name: "Team D",
                team2Score: 12,
                team2Color: .fnGold,
                timeRemaining: "00:45:00",
                isLive: false,
                matchNumber: 2,
                gameMode: .tournament
            )
        ]
    }
}

// MARK: - Initializer from SwiftData Game
extension TournamentMatch {
    init(game: Game) {
        self.id = game.id   // MUST match the persisted Game ID

        self.team1Name = game.team1.name
        self.team1Score = game.team1.score
        self.team1Image = nil
        self.team1Initials = String(game.team1.name.prefix(2)).uppercased()
        self.team1Color = .fnRed

        self.team2Name = game.team2.name
        self.team2Score = game.team2.score
        self.team2Image = nil
        self.team2Initials = String(game.team2.name.prefix(2)).uppercased()
        self.team2Color = .fnBlue

        self.timeRemaining = game.timeRemaining
        self.isLive = game.status == .live
        self.matchNumber = 0
        self.gameMode = game.gameModeEnum
    }
}
