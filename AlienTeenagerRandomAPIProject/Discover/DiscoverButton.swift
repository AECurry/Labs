//
//  DiscoverButton.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/20/25.
//

import SwiftUI

/// A custom button component for the Discover screen featuring a glass-morphism style
/// with glow effects and consistent branding.
struct DiscoverButton: View {
    // MARK: - Properties
    let title: String
    let icon: String
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            // Horizontal stack for button content layout
            HStack(spacing: 16) {
                // Leading icon with filled style for visual weight
                Image(systemName: icon + ".fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.black)
                    .frame(width: 24) // Fixed width for consistent alignment
                
                // Button title text
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)
                
                // Spacer pushes chevron to trailing edge
                Spacer()
                
                // Navigation indicator chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.gray)
            }
            // Internal padding for content breathing room
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            // Fixed dimensions for consistent button sizing
            .frame(maxWidth: 290, minHeight: 48)
            // Background with layered visual effects
            .background(
                ZStack {
                    // Primary solid background using Alabaster Gray
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.alabasterGray)
                    
                    // Border stroke for definition and glow base
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white, lineWidth: 2)
                }
            )
            // Layered shadow effects for depth and glow
            // Inner white glow simulating light emission
            .shadow(color: .white.opacity(0.6), radius: 8, x: 0, y: 0)
            // Cyan colored halo for brand consistency and alien-tech aesthetic
            .shadow(color: .cyan.opacity(0.4), radius: 12, x: 0, y: 0)
            // Depth shadow for floating effect
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        // Background for preview context
        CustomGradientBkg2()
        // Single button preview with typical usage padding
        DiscoverButton(title: "Dogs", icon: "pawprint") {}
            .padding(.horizontal, 24)
    }
}
