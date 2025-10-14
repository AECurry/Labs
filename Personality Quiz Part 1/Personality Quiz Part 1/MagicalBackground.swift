//
//  MagicalBackground.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct MagicalBackground: View {
    var body: some View {
        ZStack {
            // Magical gradient background
            LinearGradient(
                colors: [.purple, .indigo, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle sparkle overlay
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
