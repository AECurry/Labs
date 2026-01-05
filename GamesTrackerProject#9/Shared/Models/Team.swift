//
// Team.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.

import SwiftUI
import SwiftData

@Model
class Team {
    @Attribute(.unique) var id: UUID
    var name: String
    var score: Int
    var colorAssetName: String
    
    // Relationships
    @Relationship(deleteRule: .nullify, inverse: \PlayerScore.team)
    var playerScores: [PlayerScore] = []
    
    init(
        id: UUID = UUID(),
        name: String,
        score: Int = 0,
        colorAssetName: String
    ) {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.score = score
        self.colorAssetName = colorAssetName
    }
}

// MARK: - Computed Properties & Business Logic
extension Team {
    /// Computed property to get the Color from asset name
    var logoColor: Color {
        switch colorAssetName {
        case "FortniteBlue": return .fnBlue
        case "FortniteRed": return .fnRed
        case "FortniteGreen": return .fnGreen
        case "FortnitePurple": return .fnPurple
        case "FortniteGold": return .fnGold
        default: return .fnBlue
        }
    }
    
    /// Team initials for display (first 2 letters)
    var initials: String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.count >= 2 else { return trimmedName.uppercased() }
        return String(trimmedName.prefix(2)).uppercased()
    }
    
    /// Number of players in this team
    var playerCount: Int {
        playerScores.count
    }
    
    /// Average score per player (or 0 if no players)
    var averageScore: Double {
        guard !playerScores.isEmpty else { return 0 }
        return Double(score) / Double(playerCount)
    }
    
    /// Validation - team has a valid name
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if this team has a specific player
    func containsPlayer(_ playerId: UUID) -> Bool {
        playerScores.contains { $0.student.id == playerId }
    }
}

// MARK: - Team Color Enum (Optional - for type safety)
extension Team {
    enum TeamColor: String, CaseIterable {
        case blue = "FortniteBlue"
        case red = "FortniteRed"
        case green = "FortniteGreen"
        case purple = "FortnitePurple"
        case gold = "FortniteGold"
        
        var color: Color {
            switch self {
            case .blue: return .fnBlue
            case .red: return .fnRed
            case .green: return .fnGreen
            case .purple: return .fnPurple
            case .gold: return .fnGold
            }
        }
        
        var displayName: String {
            rawValue.replacingOccurrences(of: "Fortnite", with: "")
        }
    }
}

// MARK: - Sample Data & Previews
extension Team {
    static var sampleTeams: [Team] {
        [
            Team(name: "Team Alpha", colorAssetName: "FortniteBlue"),
            Team(name: "Team Bravo", colorAssetName: "FortniteRed"),
            Team(name: "Team Charlie", colorAssetName: "FortniteGreen"),
            Team(name: "Team Delta", colorAssetName: "FortnitePurple"),
            Team(name: "Team Echo", colorAssetName: "FortniteGold"),
        ]
    }
    
    /// Creates a sample team for previews
    static func createSample(name: String = "Sample Team", color: TeamColor = .blue) -> Team {
        Team(
            name: name,
            score: Int.random(in: 0...100),
            colorAssetName: color.rawValue
        )
    }
}

// MARK: - Helper Functions
extension Team {
    /// Factory method to create a team with a specific color
    static func create(name: String, color: TeamColor, score: Int = 0) -> Team {
        Team(
            name: name,
            score: score,
            colorAssetName: color.rawValue
        )
    }
    
    /// Update team score based on player scores
    func updateScoreFromPlayers() {
        score = playerScores.reduce(0) { $0 + $1.score }
    }
}
