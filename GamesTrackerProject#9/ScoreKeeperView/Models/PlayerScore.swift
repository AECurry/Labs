//
// PlayerScore.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

import SwiftData
import SwiftUI
import Foundation

@Model
final class PlayerScore {
    @Attribute(.unique) var id: UUID
    var score: Int
    var teamNumber: Int // 1 or 2 - which team this player is on
    
    // Relationships
    var student: Student
    var team: Team
    var game: Game?  // ⭐ Optional - set manually after creation
    
    init(
        id: UUID = UUID(),
        student: Student,
        team: Team,
        teamNumber: Int,
        score: Int = 0
    ) {
        self.id = id
        self.student = student
        self.team = team
        self.teamNumber = teamNumber
        self.score = score
        // ⭐ Don't set game here - set it manually after creation
    }
}

// MARK: - Convenience Extensions
extension PlayerScore {
    /// Player's display name
    var playerName: String {
        student.name
    }
    
    /// Player's avatar initial
    var playerInitial: String {
        student.initial
    }
    
    /// Player's skill level
    var skillLevel: SkillLevel {
        student.skillLevel
    }
    
    /// Team color for avatar
    var teamColor: Color {
        team.logoColor
    }
    
    /// Is this player currently winning in their team?
    var isTopScorer: Bool {
        guard let game = game else { return false }
        let teamPlayers = game.playerScores.filter { $0.teamNumber == teamNumber }
        let maxScore = teamPlayers.map { $0.score }.max() ?? 0
        return score == maxScore && score > 0
    }
}

// MARK: - Comparable for Sorting
extension PlayerScore: Comparable {
    static func < (lhs: PlayerScore, rhs: PlayerScore) -> Bool {
        // Sort by score descending (highest first)
        if lhs.score != rhs.score {
            return lhs.score > rhs.score
        }
        // If scores are equal, sort by name
        return lhs.playerName < rhs.playerName
    }
}
