//
//  GameSetup.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import Foundation

// ═══════════════════════════════════════════════════════════
// GAME SETUP MODEL
// Temporary model used during game creation flow
// Gets converted to Game + Team models when saved to SwiftData
// ═══════════════════════════════════════════════════════════

struct GameSetup {
    // GAME CONFIGURATION
    var gameMode: GameMode = .battleRoyale
    var playerCount: PlayerCount = .duo
    
    // TEAM/PLAYER SELECTION
    var team1: TeamSetup?
    var team2: TeamSetup?
    
    // SCHEDULING
    var scheduledTime: Date = Date().addingTimeInterval(3600) // Default: 1 hour from now
    var isScheduled: Bool = true // true = scheduled for later, false = start now
    
    // VALIDATION
    var isValid: Bool {
        guard let team1 = team1, let team2 = team2 else { return false }
        return team1.isValid && team2.isValid
    }
    
    // Helper: Time until game starts
    var timeUntilStart: String {
        let interval = scheduledTime.timeIntervalSinceNow
        if interval < 0 { return "Now" }
        
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// ═══════════════════════════════════════════════════════════
// TEAM SETUP (Temporary during creation)
// ═══════════════════════════════════════════════════════════

struct TeamSetup: Identifiable {
    let id = UUID()
    var name: String = ""
    var selectedStudents: [Student] = []
    var colorChoice: Color = .fnBlue
    
    var isValid: Bool {
        !name.isEmpty && !selectedStudents.isEmpty
    }
    
    // Team initials for avatar
    var initials: String {
        String(name.prefix(2).uppercased())
    }
}

// ═══════════════════════════════════════════════════════════
// PLAYER COUNT ENUM
// ═══════════════════════════════════════════════════════════

enum PlayerCount: String, CaseIterable, Identifiable {
    case single = "Solo"
    case duo = "Duo (2 Players)"
    case squad = "Squad (4 Players)"
    
    var id: String { rawValue }
    
    var playerNumber: Int {
        switch self {
        case .single: return 1
        case .duo: return 2
        case .squad: return 4
        }
    }
    
    var icon: String {
        switch self {
        case .single: return "person.fill"
        case .duo: return "person.2.fill"
        case .squad: return "person.3.fill"
        }
    }
}

// ═══════════════════════════════════════════════════════════
// STUDENT MODEL (for roster selection)
// This could be SwiftData later, but starting simple
// ═══════════════════════════════════════════════════════════

struct Student: Identifiable, Hashable {
    let id: UUID
    var name: String
    var grade: Int
    var skillLevel: SkillLevel = .intermediate
    
    init(id: UUID = UUID(), name: String, grade: Int, skillLevel: SkillLevel = .intermediate) {
        self.id = id
        self.name = name
        self.grade = grade
        self.skillLevel = skillLevel
    }
}

enum SkillLevel: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case pro = "Pro"
}

// ═══════════════════════════════════════════════════════════
// SAMPLE DATA for Testing
// ═══════════════════════════════════════════════════════════

extension Student {
    static let sampleRoster: [Student] = [
        Student(name: "Alex Martinez", grade: 11, skillLevel: .pro),
        Student(name: "Jordan Lee", grade: 10, skillLevel: .advanced),
        Student(name: "Taylor Smith", grade: 12, skillLevel: .advanced),
        Student(name: "Casey Johnson", grade: 11, skillLevel: .intermediate),
        Student(name: "Morgan Davis", grade: 9, skillLevel: .intermediate),
        Student(name: "Riley Chen", grade: 10, skillLevel: .beginner),
        Student(name: "Avery Brown", grade: 12, skillLevel: .pro),
        Student(name: "Quinn Wilson", grade: 11, skillLevel: .advanced),
        Student(name: "Skylar Garcia", grade: 10, skillLevel: .intermediate),
        Student(name: "Dakota Rodriguez", grade: 9, skillLevel: .beginner),
        Student(name: "Phoenix Martinez", grade: 12, skillLevel: .advanced),
        Student(name: "River Thompson", grade: 11, skillLevel: .intermediate)
    ]
}
