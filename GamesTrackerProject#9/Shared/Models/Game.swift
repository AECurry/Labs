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
    var gameMode: String // Store as string for persistence
    
    // Relationships
    @Relationship var team1: Team
    @Relationship var team2: Team
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        timeRemaining: String = "0:00:00",
        status: GameStatus = .upcoming,
        team1: Team,
        team2: Team,
        gameMode: GameMode = .battleRoyale // Accept enum for type safety
    ) {
        self.id = id
        self.date = date
        self.timeRemaining = timeRemaining
        self.status = status
        self.team1 = team1
        self.team2 = team2
        self.gameMode = gameMode.rawValue // Convert to string for storage
    }
}

// MARK: - Convenience Accessors & Business Logic
extension Game {
    /// Returns the GameMode enum for this game
    var gameModeEnum: GameMode {
        GameMode(rawValue: gameMode) ?? .battleRoyale
    }
    
    /// Returns the winning team, or nil if tie/no winner yet
    var winningTeam: Team? {
        if status == .completed {
            if team1.score > team2.score {
                return team1
            } else if team2.score > team1.score {
                return team2
            }
        }
        return nil
    }
    
    /// Returns true if the game is currently in progress
    var isInProgress: Bool {
        status == .live
    }
    
    /// Formatted date string for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Helper to update game time (for live games)
    func updateTimeRemaining(_ newTime: String) {
        if status == .live {
            timeRemaining = newTime
        }
    }
}

// MARK: - Game Status Enum
extension Game {
    enum GameStatus: String, Codable, CaseIterable {
        case upcoming = "Upcoming"
        case live = "Live"
        case completed = "Completed"
        case postponed = "Postponed"
        
        /// SF Symbol icon for this status
        var icon: String {
            switch self {
            case .upcoming: return "clock.fill"
            case .live: return "circle.fill"
            case .completed: return "checkmark.circle.fill"
            case .postponed: return "pause.circle.fill"
            }
        }
        
        /// Color for UI elements (badges, text, etc.)
        var displayColor: Color {
            switch self {
            case .upcoming: return .fnBlue
            case .live: return .fnRed
            case .completed: return .fnGray1
            case .postponed: return .fnGray2
            }
        }
        
        /// Background color with appropriate opacity
        var backgroundColor: Color {
            switch self {
            case .upcoming: return .fnBlue.opacity(0.15)
            case .live: return .fnRed.opacity(0.15)
            case .completed: return .fnGray1.opacity(0.15)
            case .postponed: return .fnGray2.opacity(0.15)
            }
        }
        
        /// Text to display in UI badges
        var displayText: String {
            rawValue.uppercased()
        }
        
        /// Returns true if this status should show time remaining
        var showsTimeRemaining: Bool {
            self == .live || self == .upcoming
        }
        
        /// Returns appropriate time label text
        var timeLabel: String {
            switch self {
            case .upcoming: return "STARTS IN"
            case .live: return "TIME REMAINING"
            case .completed: return "FINAL TIME"
            case .postponed: return "RESCHEDULED"
            }
        }
    }
}
