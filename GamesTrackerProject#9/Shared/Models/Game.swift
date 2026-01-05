//
//  Game.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftData
import SwiftUI
import Foundation

@Model
class Game {
    @Attribute(.unique) var id: UUID
    var date: Date
    var timeRemaining: String
    var status: GameStatus
    var gameMode: String
    
    // ⭐ Scoring rules
    var sortOrderRaw: String = "highestToLowest"
    var winConditionRaw: String = "highestScore"
    
    // Relationships
    var team1: Team
    var team2: Team
    @Relationship(deleteRule: .cascade, inverse: \PlayerScore.game) var playerScores: [PlayerScore] = []
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        timeRemaining: String = "0:00:00",
        status: GameStatus = .upcoming,
        team1: Team,
        team2: Team,
        gameMode: GameMode = .battleRoyale,
        sortOrder: SortOrder = .highestToLowest,
        winCondition: WinCondition = .highestScore
    ) {
        self.id = id
        self.date = date
        self.timeRemaining = timeRemaining
        self.status = status
        self.team1 = team1
        self.team2 = team2
        self.gameMode = gameMode.rawValue
        self.sortOrderRaw = sortOrder.rawValue
        self.winConditionRaw = winCondition.rawValue
    }
}

// MARK: - Convenience Accessors
extension Game {
    var gameModeEnum: GameMode { GameMode(rawValue: gameMode) ?? .battleRoyale }
    var sortOrder: SortOrder { SortOrder(rawValue: sortOrderRaw) ?? .highestToLowest }
    var winCondition: WinCondition { WinCondition(rawValue: winConditionRaw) ?? .highestScore }
    var hasScores: Bool { team1.score > 0 || team2.score > 0 }
    var isInProgress: Bool { status == .live }
    
    var winningTeam: Team? {
        guard status == .completed else { return nil }
        switch winCondition {
        case .highestScore:
            if team1.score > team2.score { return team1 }
            if team2.score > team1.score { return team2 }
        case .lowestScore:
            if team1.score < team2.score { return team1 }
            if team2.score < team1.score { return team2 }
        }
        return nil
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func updateTimeRemaining(_ newTime: String) {
        if status == .live { timeRemaining = newTime }
    }
    
    var sortedPlayers: [PlayerScore] {
        switch sortOrder {
        case .highestToLowest: return playerScores.sorted { $0.score > $1.score }
        case .lowestToHighest: return playerScores.sorted { $0.score < $1.score }
        }
    }
    
    func updateTeamScores() {
        team1.score = playerScores.filter { $0.teamNumber == 1 }.reduce(0) { $0 + $1.score }
        team2.score = playerScores.filter { $0.teamNumber == 2 }.reduce(0) { $0 + $1.score }
    }
}
