//
//  PlayerScoreRow.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

import SwiftUI

struct PlayerScoreRow: View {
    let playerScore: PlayerScore
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side: Player info (VERTICAL STACK)
            VStack(alignment: .leading, spacing: 4) {
                // Name
                Text(playerScore.playerName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.fnWhite)
                
                // Skill Level with icon
                HStack(spacing: 6) {
                    Image(systemName: playerScore.skillLevel.icon)
                        .font(.caption2)
                        .foregroundColor(playerScore.skillLevel.color)
                    
                    Text(playerScore.skillLevel.rawValue)
                        .font(.caption)
                        .foregroundColor(playerScore.skillLevel.color)
                }
                
                // Team badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(playerScore.teamColor)
                        .frame(width: 8, height: 8)
                    
                    Text("Team \(playerScore.teamNumber)")
                        .font(.caption)
                        .foregroundColor(.fnGray1)
                }
            }
            
            Spacer()
            
            // Player's current score
            Text("\(playerScore.score)")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.fnWhite)
                            .frame(minWidth: 40)
                            .padding(.horizontal, 8)
            
            // Score Stepper (right side)
            HStack(spacing: 12) {
                // Decrement Button
                Button {
                    onDecrement()
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(playerScore.score > 0 ? .fnRed : .fnGray1)
                }
                .disabled(playerScore.score <= 0)
                
                // Increment Button
                Button {
                    onIncrement()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.fnGreen)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.fnBlack.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    playerScore.isTopScorer ? Color.fnGold.opacity(0.5) : Color.clear,
                    lineWidth: 2
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        AnimatedGridBackground()
        
        VStack(spacing: 16) {
            // Team 1 player example
            PlayerScoreRow(
                playerScore: {
                    let student = Student(name: "Sam Sowell", grade: 11, skillLevel: .intermediate)
                    let team = Team(name: "Team Alpha", colorAssetName: "FortniteBlue")
                    let ps = PlayerScore(student: student, team: team, teamNumber: 1, score: 15)
                    return ps
                }(),
                onIncrement: {},
                onDecrement: {}
            )
            
            // Team 2 player example
            PlayerScoreRow(
                playerScore: {
                    let student = Student(name: "Maria Garcia", grade: 10, skillLevel: .advanced)
                    let team = Team(name: "Team Bravo", colorAssetName: "FortniteRed")
                    let ps = PlayerScore(student: student, team: team, teamNumber: 2, score: 12)
                    return ps
                }(),
                onIncrement: {},
                onDecrement: {}
            )
            
            // Zero score example
            PlayerScoreRow(
                playerScore: {
                    let student = Student(name: "Nick Cartwright", grade: 9, skillLevel: .beginner)
                    let team = Team(name: "Team Alpha", colorAssetName: "FortniteBlue")
                    let ps = PlayerScore(student: student, team: team, teamNumber: 1, score: 0)
                    return ps
                }(),
                onIncrement: {},
                onDecrement: {}
            )
        }
        .padding()
    }
}
