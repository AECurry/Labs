//
//  CardView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/8/25.
//

import SwiftUI

// MARK: - Card View
/// The building block that creates the individual card component with two-tone design (colored header + white content)
/// Used throughout the app for displaying lesson content in a consistent, polished format
struct CardView: View {
    // MARK: - Properties
    let emoji: String    // Visual icon representing card content (e.g., "📚", "👨‍🏫")
    let title: String    // Header text displayed in the colored bar
    let content: String  // Main content text in the white area
    let isTopCard: Bool  // Determines corner styling for stacked card appearances
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Colored Header Bar
            /// Burgundy header with emoji and title in white text
            /// Enhanced with larger font and taller height for better readability
            HStack {
                Text(emoji)
                    .font(.system(size: 16))  // Standard emoji size
                Text(title)
                    .font(.system(size: 14, weight: .bold)) // Larger font for better readability
                    .foregroundColor(.white)  // High contrast on colored background
                Spacer()  // Pushes content to leading edge
            }
            .padding(.horizontal, 16)  // Side padding for content spacing
            .frame(height: 48) // Taller header for improved visual presence
            .background(MountainlandColors.burgundy3)  // Brand burgundy color
            
            // MARK: - Content Area
            /// White background area for main content text
            /// Enhanced with larger font and more vertical space
            HStack {
                Text(content)
                    .font(.system(size: 14, weight: .bold)) // Larger font for better readability
                    .foregroundColor(MountainlandColors.smokeyBlack)  // High contrast text
                    .lineLimit(3)              // Maximum 3 lines to prevent overflow
                    .minimumScaleFactor(0.9)   // Slight text scaling if needed
                Spacer()  // Pushes content to leading edge
            }
            .padding(.horizontal, 16)    // Side padding for text
            .frame(height: 56, alignment: .top) // Taller content area for more text
            .padding(.top, 16)           // Comfortable top padding for text positioning
            .background(Color.white)     // Clean white background for content
        }
        .background(Color.white)  // Overall card background
        .frame(width: 368)        // Fixed card width for consistent layout (wider than CalendarCardView)
        
        // MARK: - Card Shape and Corners
        /// Conditional corner rounding based on card position in stack
        /// Top cards have flat tops when stacked, standalone cards have rounded corners
        .clipShape(
            .rect(
                topLeadingRadius: isTopCard ? 0 : 8,    // Flat top when stacked, rounded when standalone
                bottomLeadingRadius: 8,                 // Always rounded bottom corners
                bottomTrailingRadius: 8,                // Always rounded bottom corners
                topTrailingRadius: isTopCard ? 0 : 8    // Flat top when stacked, rounded when standalone
            )
        )
        
        // MARK: - Card Shadow
        /// Enhanced shadow for more visual depth and card elevation
        .shadow(
            color: .black.opacity(0.15), // ← Darker shadow for stronger visual separation
            radius: 4,                   // ← Larger blur radius for softer shadow
            x: 0,                        // No horizontal offset
            y: 2                         // ← More vertical offset for pronounced floating effect
        )
    }
}
