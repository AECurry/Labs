//
//  CountdownAnimationView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

/// CHILD: Displays numbers and GO! text in foreground
/// DEPENDENCY: Receives @Bindable viewModel from parent
/// SOLID: Single Responsibility - renders number/text animations only
/// TRANSITION: Uses .asymmetric for different insert/remove animations
import SwiftUI

/// Shows the countdown animation area.
/// Displays numbers 4-3-2-1 and then "GO!" when countdown finishes.
struct CountdownAnimationView: View {
    @Bindable var viewModel: CountdownViewModel
    
    var body: some View {
        ZStack {
            // Show current number with fade-out state
            if let currentNumber = viewModel.currentNumber {
                CountdownNumberView(
                    number: currentNumber,
                    isActive: true,
                    isFadingOut: viewModel.currentNumberIsFadingOut
                )
                .transition(
                    .asymmetric(
                        insertion: .scale(scale: 0.5).combined(with: .opacity),
                        removal: .opacity.combined(with: .scale(scale: 1.5))
                    )
                )
                .offset(y: -120) // Move numbers higher
            }
            
            // Show GO! text
            if viewModel.showGoText {
                Text("GO!")
                    .font(.system(size: 100, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .red, location: 0.0),
                                .init(color: .orange, location: 0.25),
                                .init(color: .red, location: 0.5),
                                .init(color: .orange, location: 0.75),
                                .init(color: .red, location: 1.0)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .yellow.opacity(0.8), radius: 30)
                    .scaleEffect(viewModel.showGoText ? 1.0 : 0.5)
                    .opacity(viewModel.showGoText ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7),
                        value: viewModel.showGoText
                    )
                    .transition(.scale.combined(with: .opacity))
                    .offset(y: -120) // Move GO! higher
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
