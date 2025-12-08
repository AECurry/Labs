//
//  CountdownNumberView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

import SwiftUI

/// Shows a single countdown number (3, 2, or 1) with two animations:
/// 1. **Appears**: Scales up from 50% → 100% while fading in
/// 2. **Disappears**: Fades out (no scaling change)
struct CountdownNumberView: View {
    /// What number to show (3, 2, or 1)
    let number: Int
    
    /// Whether number is fully visible and scaled up
    let isActive: Bool
    
    /// Whether number is fading away
    let isFadingOut: Bool
    
    var body: some View {
        Text("\(number)")
            // Big, bold blue number
            .font(.system(size: 100, weight: .bold, design: .rounded))
            .foregroundColor(.blue)
            
            /// ANIMATION 1: Scale
            /// When active: Full size (100%)
            /// When inactive: Half size (50%) - scales up when appearing
            .scaleEffect(isActive ? 1.0 : 0.5)
            
            /// ANIMATION 2: Opacity (transparency)
            /// When fading out: Invisible (0%)
            /// When active: Fully visible (100%)
            /// When inactive: Invisible (0%) - hasn't appeared yet
            .opacity(isFadingOut ? 0 : (isActive ? 1 : 0))
            
            /// First animation: Scale up + fade in (smooth ease)
            .animation(.easeInOut(duration: 0.3), value: isActive)
            
            /// Second animation: Fade out only (gentle ease out)
            .animation(.easeOut(duration: 0.5), value: isFadingOut)
    }
}
