//
//  CelebrationView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

struct CelebrationView: View {
    let winnerName: String
    let winnerPoints: Int
    @State private var confettiScale: CGFloat = 0
    @State private var trophyRotation: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            // Trophy with rotation
            ZStack {
                // Confetti effect
                ForEach(0..<12) { i in
                    Circle()
                        .fill(confettiColor(at: i))
                        .frame(width: 24, height: 24)
                        .scaleEffect(confettiScale)
                        .offset(
                            x: confettiOffsetX(at: i),
                            y: confettiOffsetY(at: i)
                        )
                }
                
                // Trophy icon with animation
                Image(systemName: "trophy.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.fnGold)
                    .rotationEffect(.degrees(trophyRotation))
                    .shadow(color: .fnGold.opacity(0.5), radius: 10)
            }
            .frame(height: 100)
            .onAppear {
                // Animate confetti
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    confettiScale = 1
                }
                
                // Animate trophy rotation
                withAnimation(.easeInOut(duration: 0.5).repeatCount(2, autoreverses: true)) {
                    trophyRotation = 360
                }
                
                // Animate text
                withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
                    textOpacity = 1
                }
            }
            
            // Winner text
            VStack(spacing: 8) {
                Text("TODAY'S WINNERS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.fnGold)
                    .kerning(2)
                    .opacity(textOpacity)
                
                Text(winnerName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.fnWhite)
                    .opacity(textOpacity)
                
                Text("\(winnerPoints) points")
                    .font(.subheadline)
                    .foregroundColor(.fnGray1)
                    .opacity(textOpacity)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.fnBlack.opacity(0.7))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.fnGold, .fnGold.opacity(0.5), .fnGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .padding(.horizontal)
        .shadow(color: .fnGold.opacity(0.3), radius: 20)
    }
    
    private func confettiColor(at index: Int) -> Color {
        let colors: [Color] = [.fnGold, .fnSilver, .fnBlue, .fnGreen, .fnPurple, .fnRed]
        return colors[index % colors.count]
    }
    
    private func confettiOffsetX(at index: Int) -> CGFloat {
        let angles = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]
        let radians = Double(angles[index]) * .pi / 180
        return CGFloat(cos(radians) * 40)
    }
    
    private func confettiOffsetY(at index: Int) -> CGFloat {
        let angles = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]
        let radians = Double(angles[index]) * .pi / 180
        return CGFloat(sin(radians) * 40)
    }
}
