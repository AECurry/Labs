//
//  CountdownAnimationView.swift
//  AnimationsLab
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

/// Shows the countdown animation area.
/// Displays numbers 3-2-1 and then "GO!" when countdown finishes.
struct CountdownAnimationView: View {
    /// Connects to our ViewModel that manages the animation state
    @Bindable var viewModel: CountdownViewModel
    
    var body: some View {
        ZStack {
            // Show current number (3, 2, or 1)
            if let currentNumber = viewModel.currentNumber {
                CountdownNumberView(
                    number: currentNumber,
                    isActive: true,
                    isFadingOut: false
                )
                .transition(.opacity) // Fade in/out animation
            }
            
            // Show "GO!" when countdown finishes
            if viewModel.showGoText {
                GoTextView()
                    .transition(.scale.combined(with: .opacity)) // Scale + fade animation
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Shows the "GO!" text with a pulsing animation
struct GoTextView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Text("GO!")
            .font(.system(size: 120, weight: .black, design: .rounded))
            .foregroundColor(.green)
            .scaleEffect(isAnimating ? 1.2 : 1.0) // Pulsing scale
            .opacity(isAnimating ? 1 : 0.8)      // Pulsing opacity
            .onAppear {
                // Start continuous pulsing animation
                withAnimation(
                    .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}
