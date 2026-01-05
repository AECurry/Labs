//
//  RankingModel.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import Foundation
import SwiftUI

// MARK: - Ranking Types
enum RankingTimeframe: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

enum RankingMode: String, CaseIterable {
    case solo = "Solo"
    case duo = "Duo"
    case squad = "Squad"
    
    var iconName: String {
        switch self {
        case .solo: return "person.fill"
        case .duo: return "person.2.fill"
        case .squad: return "person.3.fill"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .solo: return .fnBlue
        case .duo: return .fnGreen
        case .squad: return .fnPurple
        }
    }
}

// MARK: - Protocol for Rankable Items
protocol Rankable: Identifiable {
    var rank: Int { get set }
    var points: Int { get }
    var wins: Int { get }
    var winRate: Double { get }
    var displayName: String { get }
    var subtitle: String { get }
}

// MARK: - Data Models
struct PlayerRank: Rankable {
    let id = UUID()
    var rank: Int
    let playerName: String
    let points: Int
    let wins: Int
    let winRate: Double
    let matchesPlayed: Int
    let kills: Int
    let averagePlacement: Double
    
    var displayName: String { playerName }
    var subtitle: String { "\(wins) wins • \(Int(winRate * 100))% WR" }
}

struct DuoTeamRank: Rankable {
    let id = UUID()
    var rank: Int
    let teamName: String
    let player1: String
    let player2: String
    let points: Int
    let wins: Int
    let winRate: Double
    
    var displayName: String { teamName }
    var subtitle: String { "\(player1) & \(player2)" }
}

struct SquadTeamRank: Rankable {
    let id = UUID()
    var rank: Int
    let squadName: String
    let players: [String]
    let points: Int
    let wins: Int
    let winRate: Double
    
    var displayName: String { squadName }
    var subtitle: String { "\(players.count) players • \(wins) wins" }
}
