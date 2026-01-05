//
//  Game+Status.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import Foundation
import SwiftUI 

// MARK: - Status Business Logic
extension Game {
    /// Updates game status based on current time and scores
    func updateStatusBasedOnCurrentTime() {
        let now = Date()
        
        // Upcoming → Live/Completed
        if status == .upcoming && now > date {
            if hasScores {
                status = .live
                if timeRemaining == "0:00:00" { timeRemaining = "1:00:00" }
            } else if now > date.addingTimeInterval(7200) {
                status = .completed
                timeRemaining = "0:00:00"
            }
        }
        
        // Live → Completed/Postponed
        if status == .live && timeRemaining == "0:00:00" {
            status = hasScores ? .completed : .postponed
        }
    }
    
    /// Returns true if game should be displayed as completed in UI
    var shouldShowAsCompleted: Bool {
        if status == .completed { return true }
        if (status == .upcoming || status == .live) && hasScores { return true }
        let threeHoursAgo = Date().addingTimeInterval(-10800)
        return date < threeHoursAgo
    }
}

// MARK: - Game Status Enum
extension Game {
    enum GameStatus: String, Codable, CaseIterable {
        case upcoming = "Upcoming", live = "Live", completed = "Completed", postponed = "Postponed"
        
        var icon: String {
            switch self {
            case .upcoming: return "clock.fill"
            case .live: return "circle.fill"
            case .completed: return "checkmark.circle.fill"
            case .postponed: return "pause.circle.fill"
            }
        }
        
        var displayColor: Color {
            switch self {
            case .upcoming: return .fnBlue
            case .live: return .fnRed
            case .completed: return .fnGray1
            case .postponed: return .fnGray2
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .upcoming: return .fnBlue.opacity(0.15)
            case .live: return .fnRed.opacity(0.15)
            case .completed: return .fnGray1.opacity(0.15)
            case .postponed: return .fnGray2.opacity(0.15)
            }
        }
        
        var displayText: String { rawValue.uppercased() }
        var showsTimeRemaining: Bool { self == .live || self == .upcoming }
        
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
