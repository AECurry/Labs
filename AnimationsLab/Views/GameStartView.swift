//
//  GameStartView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

import SwiftUI
import Combine

/// Shows the game controls: Start button when idle, "Get Ready..." during countdown.
struct GameStartView: View {
    /// Shows "Get Ready..." during 4-3-2-1 countdown (hides when GO! appears)
    let shouldShowGetReady: Bool
    
    /// Whether the countdown is currently running
    let isCountdownActive: Bool
    
    /// What happens when Start button is tapped
    let onStartTapped: () -> Void
    
    
    var body: some View {
        VStack(spacing: 30) {
            // Show "Start Game" button only when NOT counting down
            if !isCountdownActive {
                Button(action: onStartTapped) {
                    Text("Start Game")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                    // Blue to purple gradient background
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                }
                .buttonStyle(ScaleButtonStyle()) // Adds press animation
            }
            
            // Show countdown numbers when countdown is active
            if shouldShowGetReady {
                Text("Get Ready...")
                    .font(.title3)
                    .foregroundColor(.orange)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: shouldShowGetReady)
        .animation(.easeInOut(duration: 0.3), value: isCountdownActive)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

