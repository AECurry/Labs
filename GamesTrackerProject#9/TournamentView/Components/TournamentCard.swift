//
//  TournamentCard.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI
import SwiftData

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
    
    var neonGlowColor: Color {
        switch self {
        case .live: return Color(red: 0.6, green: 0.0, blue: 1.6)
        case .gameStarts: return .fnBlue
        case .finished: return .fnGray1
        }
    }
    
    static func from(match: TournamentMatch) -> GameCardStatus {
        switch match.status {
        case .live: return .live
        case .upcoming: return .gameStarts
        case .completed, .postponed: return .finished
        }
    }
}

// MARK: - Main Card View
struct TournamentCard: View {
    let match: TournamentMatch
    @Environment(TournamentViewModel.self) private var viewModel
    
    private let cardWidth: CGFloat = 337
    private let internalPadding: CGFloat = 24
    private let cornerRadius: CGFloat = 16
    
    private var displayStatus: GameCardStatus {
        let game = viewModel.findGame(by: match.id)
        if let game = game, game.shouldShowAsCompleted {
            return .finished
        }
        return GameCardStatus.from(match: match)
    }
    
    var body: some View {
        ZStack {
            // GLOW EFFECTS
            RoundedRectangle(cornerRadius: cornerRadius + 8)
                .fill(displayStatus.neonGlowColor)
                .frame(width: cardWidth + 16)
                .blur(radius: 32)
                .opacity(0.1)
            
            RoundedRectangle(cornerRadius: cornerRadius + 4)
                .fill(displayStatus.neonGlowColor)
                .frame(width: cardWidth + 8)
                .blur(radius: 12)
                .opacity(0.8)
            
            RoundedRectangle(cornerRadius: cornerRadius + 1)
                .fill(displayStatus.neonGlowColor)
                .frame(width: cardWidth + 4)
                .blur(radius: 4)
                .opacity(1.5)
            
            // MAIN CARD CONTENT
            cardContent
                .background(Color.fnGray3)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(displayStatus.neonGlowColor, lineWidth: 1.5)
                        .opacity(0.9)
                )
        }
    }
    
    private var cardContent: some View {
        VStack(spacing: 0) {
            // STATUS BADGE
            HStack {
                StatusBadge(status: displayStatus)
                Spacer()
            }
            .padding(.bottom, 16)
            
            // GAME MODE
            Text(match.gameMode.rawValue.uppercased())
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(displayStatus == .finished ? .fnGray1 : .fnBlack)
                .padding(.bottom, 20)
            
            // TEAMS
            HStack(spacing: 32) {
                TeamSection(
                    name: match.team1Name,
                    initials: match.team1Initials,
                    color: match.team1Color
                )
                
                Text("Vs")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(displayStatus == .finished ? .fnGray1 : .fnBlack)
                
                TeamSection(
                    name: match.team2Name,
                    initials: match.team2Initials,
                    color: match.team2Color
                )
            }
            .padding(.bottom, 24)
            
            // SCORE LABEL
            Text("Score")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(displayStatus.badgeColor)
                .padding(.bottom, 8)
            
            // SCORES
            HStack(spacing: 116) {
                ScoreNumber(score: match.team1Score)
                    .foregroundColor(displayStatus == .finished ? .fnGray1 : .fnBlack)
                ScoreNumber(score: match.team2Score)
                    .foregroundColor(displayStatus == .finished ? .fnGray1 : .fnBlack)
            }
            .padding(.bottom, 24)
            
            // TIME
            VStack(spacing: 4) {
                Text(displayStatus.timeLabelText)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(displayStatus == .finished ? .fnGray1 : displayStatus.badgeColor)
                
                Text(timeDisplayText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(displayStatus == .finished ? .fnGray1 : .fnBlack)
            }
            .padding(.bottom, 16)
        }
        .padding(internalPadding)
        .frame(width: cardWidth)
        .background(Color.fnGray3)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(displayStatus.neonGlowColor, lineWidth: 1.5)
                .opacity(0.9)
        )
        .overlay(
            displayStatus == .finished ?
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.fnBlack.opacity(0.05)) : nil
        )
    }
    
    private var timeDisplayText: String {
        switch displayStatus {
        case .live: return match.timeRemaining
        case .gameStarts: return "In \(match.timeRemaining)"
        case .finished: return "00:00:00"
        }
    }
}

// STATUS BADGE
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

// TEAM SECTION
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

// SCORE NUMBER
private struct ScoreNumber: View {
    let score: Int
    
    var body: some View {
        Text(String(format: "%02d", score))
            .font(.system(size: 56, weight: .bold))
            .foregroundColor(.fnBlack)
    }
}

// MARK: - Simple Mock for Previews
class PreviewTournamentViewModel: TournamentViewModel {
    init() {
        let container = try! ModelContainer(
            for: Game.self, Team.self, Student.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        super.init(modelContext: container.mainContext)
    }
    
    override func findGame(by id: UUID) -> Game? {
        // Return nil for previews - card will use match data directly
        return nil
    }
}

// PREVIEWS
#Preview("Live Game") {
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
                gameMode: .battleRoyale,
                status: .live
            )
        )
        .environment(PreviewTournamentViewModel())
    }
}

#Preview("Completed Game") {
    ZStack {
        AnimatedGridBackground()
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
                gameMode: .creative,
                status: .completed
            )
        )
        .environment(PreviewTournamentViewModel())
    }
}

#Preview("All Types") {
    ScrollView {
        ZStack {
            AnimatedGridBackground()
            VStack(spacing: 20) {
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
                        gameMode: .battleRoyale,
                        status: .live
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
                        gameMode: .zeroBuild,
                        status: .upcoming
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
                        gameMode: .creative,
                        status: .completed
                    )
                )
            }
            .padding()
            .environment(PreviewTournamentViewModel())
        }
    }
}
