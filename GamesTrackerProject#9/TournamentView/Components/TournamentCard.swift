//
//  TournamentCard.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI

// MARK: - Game Status Enum
enum GameCardStatus {
    case live
    case gameStarts
    case finished
    
    var badgeText: String {
        switch self {
        case .live: return "LIVE"
        case .gameStarts: return "GAME STARTS"
        case .finished: return "FINISHED"
        }
    }
    
    var badgeColor: Color {
        switch self {
        case .live: return .fnRed
        case .gameStarts: return .fnBlue
        case .finished: return .fnGray1
        }
    }
    
    var timeLabelText: String {
        switch self {
        case .live: return "TIME REMAINING"
        case .gameStarts: return "GAME STARTS"
        case .finished: return "FINISHED"
        }
    }
    
    // NEON GLOW: Different glow colors based on status
    var neonGlowColor: Color {
        switch self {
        case .live: return Color(red: 0.6, green: 0.0, blue: 1.6)    // Cyan-green (electric/Matrix green)
        case .gameStarts: return .fnBlue     // Blue for upcoming
        case .finished: return .fnGray1      // Subtle gray for finished
        }
    }
    
    // Helper to determine status based on match data
    static func from(match: TournamentMatch) -> GameCardStatus {
        if match.isLive {
            return .live
        } else if match.team1Score > 0 || match.team2Score > 0 {
            return .finished
        } else {
            return .gameStarts
        }
    }
}

// MARK: - Main Card View
struct TournamentCard: View {
    let match: TournamentMatch
    let gameStatus: GameCardStatus
    
    private let cardWidth: CGFloat = 337
    private let internalPadding: CGFloat = 24
    private let cornerRadius: CGFloat = 16
    
    // Color per game mode - changes based on status
    private var gameModeColor: Color {
        gameStatus == .finished ? .fnGray1 : .fnBlack
    }
    
    // Initialize with match and auto-calculate status
    init(match: TournamentMatch) {
        self.match = match
        self.gameStatus = GameCardStatus.from(match: match)
    }
    
    var body: some View {
        ZStack {
            // ═══════════════════════════════════════════════════════════
            // NEON GLOW EFFECT - Three-layer system for depth and realism
            // ═══════════════════════════════════════════════════════════
            
            // LAYER 1: OUTER GLOW (Soft atmospheric halo)
            // - Purpose: Creates the furthest, most diffuse glow
            // - Extends 20px beyond card (reduced from 30px)
            // - Heavily blurred (20px) for soft falloff
            // - Lightest opacity (0.3) to avoid overwhelming
            RoundedRectangle(cornerRadius: cornerRadius + 8)
                .fill(gameStatus.neonGlowColor)
                .frame(width: cardWidth + 16)
                .blur(radius: 32)
                .opacity(0.1)
            
            // LAYER 2: MIDDLE GLOW (Main visible glow)
            // - Purpose: The primary glow most visible to the eye
            // - Extends 10px beyond card (reduced from 15px)
            // - Medium blur (12px) for smooth gradient
            // - Medium opacity (0.5, increased from 0.6) for brightness
            RoundedRectangle(cornerRadius: cornerRadius + 4)
                .fill(gameStatus.neonGlowColor)
                .frame(width: cardWidth + 8)
                .blur(radius: 12)
                .opacity(0.8)
            
            // LAYER 3: INNER GLOW (Brightest edge)
            // - Purpose: Creates the intense glow closest to card edge
            // - Extends only 4px beyond card (reduced from 6px)
            // - Light blur (6px) to maintain definition
            // - Highest opacity (0.7, reduced from 0.8) for bright edge
            RoundedRectangle(cornerRadius: cornerRadius + 1)
                .fill(gameStatus.neonGlowColor)
                .frame(width: cardWidth + 4)
                .blur(radius: 4)
                .opacity(1.5)
            
            // ═══════════════════════════════════════════════════════════
            // MAIN CARD CONTENT
            // ═══════════════════════════════════════════════════════════
            
            cardContent
                .background(Color.fnGray3) // Card background color
                .cornerRadius(cornerRadius)
                .overlay(
                    // CRISP BORDER: Sharp line for definition
                    // - 1.5px colored border matches glow color
                    // - High opacity (0.9) for clear edge definition
                    // - Separates card from glow effect
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(gameStatus.neonGlowColor, lineWidth: 1.5)
                        .opacity(0.9)
                )
        }
    }
    
    // ═══════════════════════════════════════════════════════════
    // CARD CONTENT - All visual elements inside the card
    // ═══════════════════════════════════════════════════════════
    private var cardContent: some View {
        VStack(spacing: 0) {
            // STATUS BADGE (Top-left: LIVE, GAME STARTS, or FINISHED)
            HStack {
                StatusBadge(status: gameStatus)
                Spacer()
            }
            .padding(.bottom, 16)
            
            // GAME MODE LABEL (e.g., "BATTLE ROYALE")
            Text(match.gameMode.rawValue.uppercased())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(gameModeColor) // Gray for finished, black otherwise
                .padding(.bottom, 20)
            
            // TEAM MATCHUP ROW (Avatar + Name for each team)
            HStack(spacing: 32) {
                TeamSection(
                    name: match.team1Name,
                    initials: match.team1Initials,
                    color: match.team1Color
                )
                
                // "Vs" separator between teams
                Text("Vs")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(gameStatus == .finished ? .fnGray1 : .fnBlack)
                
                TeamSection(
                    name: match.team2Name,
                    initials: match.team2Initials,
                    color: match.team2Color
                )
            }
            .padding(.bottom, 24)
            
            // SCORE LABEL (Colored based on game status)
            Text("Score")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(gameStatus.badgeColor) // Red/Blue/Gray
                .padding(.bottom, 8)
            
            // SCORE NUMBERS (Large 2-digit format)
            HStack(spacing: 116) {
                ScoreNumber(score: match.team1Score)
                    .foregroundColor(gameStatus == .finished ? .fnGray1 : .fnBlack)
                ScoreNumber(score: match.team2Score)
                    .foregroundColor(gameStatus == .finished ? .fnGray1 : .fnBlack)
            }
            .padding(.bottom, 24)
            
            // TIME SECTION (Label + countdown/time display)
            VStack(spacing: 4) {
                // Time label changes: "TIME REMAINING" / "GAME STARTS" / "FINISHED"
                Text(gameStatus.timeLabelText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(gameStatus.badgeColor)
                
                // Actual time value (formatted based on status)
                Text(timeDisplayText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(gameStatus == .finished ? .fnGray1 : .fnBlack)
            }
            .padding(.bottom, 16)
        }
        .padding(internalPadding) // 24px padding around all content
        .frame(width: cardWidth) // Fixed width: 337px
        .overlay(
            // DIMMING OVERLAY for completed games
            // Adds subtle black tint to indicate game is over
            gameStatus == .finished ?
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.fnBlack.opacity(0.05)) : nil
        )
    }
    
    // ═══════════════════════════════════════════════════════════
    // TIME DISPLAY LOGIC
    // ═══════════════════════════════════════════════════════════
    // Returns appropriate time string based on game status:
    // - LIVE: Shows actual remaining time (e.g., "0:15:32")
    // - UPCOMING: Adds "In" prefix (e.g., "In 1:30:00")
    // - FINISHED: Always shows "00:00:00"
    private var timeDisplayText: String {
        switch gameStatus {
        case .live:
            return match.timeRemaining
        case .gameStarts:
            return "In \(match.timeRemaining)"
        case .finished:
            return "00:00:00"
        }
    }
}

// MARK: - Status Badge Component
private struct StatusBadge: View {
    let status: GameCardStatus
    
    var body: some View {
        HStack(spacing: 6) {
            if status == .live {
                Circle()
                    .fill(status.badgeColor)
                    .frame(width: 8, height: 8)
            }
            
            Text(status.badgeText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(status.badgeColor)
        }
        .frame(height: 28)
        .padding(.horizontal, 12)
        .background(status.badgeColor.opacity(0.15))
        .cornerRadius(24)
    }
}

// MARK: - Team Section
private struct TeamSection: View {
    let name: String
    let initials: String
    let color: Color
    
    private let avatarSize: CGFloat = 72
    private let maxTeamNameWidth: CGFloat = 80
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: avatarSize, height: avatarSize)
                
                Text(initials.prefix(2))
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.fnWhite)
            }
            
            Text(name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.fnBlack)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: maxTeamNameWidth, alignment: .center)
        }
    }
}

// MARK: - Score Number
private struct ScoreNumber: View {
    let score: Int
    
    var body: some View {
        Text(String(format: "%02d", score))
            .font(.system(size: 56, weight: .bold))
            .foregroundColor(.fnBlack)
    }
}

// MARK: - Previews
#Preview("Live Game - Green Glow") {
    ZStack {
        AnimatedGridBackground()
        
        TournamentCard(
            match: TournamentMatch(
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
                gameMode: .battleRoyale
            )
        )
    }
}

#Preview("All Status Types") {
    ScrollView {
        ZStack {
            AnimatedGridBackground()
            
            VStack(spacing: 40) {
                TournamentCard(
                    match: TournamentMatch(
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
                        gameMode: .battleRoyale
                    )
                )
                
                TournamentCard(
                    match: TournamentMatch(
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
                        gameMode: .zeroBuild
                    )
                )
                
                TournamentCard(
                    match: TournamentMatch(
                        team1Name: "Victory Squad",
                        team1Score: 25,
                        team1Initials: "VS",
                        team1Color: .fnGreen,
                        team2Name: "Storm Chasers",
                        team2Score: 18,
                        team2Initials: "SC",
                        team2Color: .fnPurple,
                        timeRemaining: "0:00:00",
                        isLive: false,
                        matchNumber: 3,
                        gameMode: .creative
                    )
                )
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 40)
        }
    }
}
