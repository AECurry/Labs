//
//  MagicalBackground.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

// Creates an enchanting background for the quiz app
struct MagicalBackground: View {
    var body: some View {
        ZStack {
            // Main gradient - gives magical color transition from purple to blue
            LinearGradient(
                colors: [.purple, .indigo, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Sparkle effect - random white circles that look like stars/twinkles
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<15) { i in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: CGFloat.random(in: 2...6))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    MagicalBackground()
}
