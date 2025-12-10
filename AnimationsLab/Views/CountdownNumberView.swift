//
//  CountdownNumberView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

/// CHILD: Renders individual countdown numbers with spin animation
/// SOLID: Single Responsibility - handles number display and animations
/// TRANSITION: Implements asymmetric insert/removal with rotation effect
import SwiftUI

/// Shows a single countdown number (4, 3, 2, or 1) with animations:
/// 1. **Appears**: Scales DOWN from 150% → 100% while fading in
/// 2. **Disappears**: Spins 360 degrees while fading out and scaling up
struct CountdownNumberView: View {
    let value: String
    let isActive: Bool
    let isFadingOut: Bool
    @State private var spinAngle: Double = 0
    
    // Convenience initializer for Int values
    init(number: Int, isActive: Bool, isFadingOut: Bool) {
        self.value = "\(number)"
        self.isActive = isActive
        self.isFadingOut = isFadingOut
    }
    
    // Initializer for String values (for "Go!")
    init(value: String, isActive: Bool, isFadingOut: Bool) {
        self.value = value
        self.isActive = isActive
        self.isFadingOut = isFadingOut
    }
    
    var body: some View {
        Text(value)
            .font(.system(size: 100, weight: .bold, design: .rounded))
            .foregroundColor(.blue)
            
            // Scale DOWN from 150% to 100%
            .scaleEffect(isActive ? 1.0 : 1.5)
            
            // Rotate when fading out
            .rotationEffect(.degrees(spinAngle))
            
            // Scale up while spinning
            .scaleEffect(isFadingOut ? 1.5 : (isActive ? 1.0 : 1.5))
            
            .opacity(isFadingOut ? 0 : (isActive ? 1 : 0))
            
            // Use combined transition for appearing
            .animation(
                .spring(response: 0.5, dampingFraction: 0.7)
                .delay(0.1),
                value: isActive
            )
            
            // Asymmetric transition for disappearing
            .transition(
                .asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                )
            )
            
            // Trigger spin animation when fading out starts
            .onChange(of: isFadingOut) { oldValue, newValue in
                if newValue {
                    // Spin 360 degrees while scaling up
                    withAnimation(.easeIn(duration: 0.4)) {
                        spinAngle = 360
                    }
                } else {
                    spinAngle = 0
                }
            }
            
            // Separate animation for fade out and scale
            .animation(
                .easeOut(duration: 0.4),
                value: isFadingOut
            )
    }
}
