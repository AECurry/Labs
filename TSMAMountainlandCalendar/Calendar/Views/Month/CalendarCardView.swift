//
//  CalendarCardView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

// MARK: - Calendar Card View
/// Custom card component with colored header and content area
/// Features two-tone design with emoji, title, and multi-line content
/// Supports both top-positioned and stacked card appearances
/// This is the card that goes inside the CalendarCardStack
struct CalendarCardView: View {
    // MARK: - Properties
    let emoji: String        // Visual icon representing card content (e.g., "📚", "✏️")
    let title: String        // Header text displayed in the colored bar
    let content: String      // Main content text in the white area
    let isTopCard: Bool      // Determines if card has rounded top corners for visual hierarchy
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Colored Header Bar
            /// Burgundy header with emoji and title in white text
            /// Fixed height for consistent appearance across all cards
            HStack {
                Text(emoji)
                    .font(.system(size: 16))  // Standard emoji size
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)  // High contrast on colored background
                Spacer()  // Pushes content to leading edge
            }
            .padding(.horizontal, 16)  // Side padding for content spacing
            .frame(height: 48)         // Fixed header height
            .background(MountainlandColors.burgundy3)  // Brand color for header
            
            // MARK: - Content Area
            /// White background area for main content text
            /// Supports multi-line content with text scaling
            HStack {
                Text(content)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(MountainlandColors.smokeyBlack)  // High contrast text
                    .lineLimit(3)              // Maximum 3 lines to prevent overflow
                    .minimumScaleFactor(0.9)   // Slight text scaling if needed
                Spacer()  // Pushes content to leading edge
            }
            .padding(.horizontal, 16)    // Side padding for text
            .frame(height: 56, alignment: .top)  // Fixed content height, top-aligned
            .padding(.top, 16)           // Top padding for text positioning
            .background(Color.white)     // Clean white background for content
        }
        .background(Color.white)  // Overall card background
        .frame(width: 332)        // Fixed card width for consistent layout
        // MARK: - Card Shape and Corners
        /// Applies conditional corner rounding based on card position
        /// Top cards have rounded top corners, stacked cards have flat tops
        .clipShape(
            .rect(
                topLeadingRadius: isTopCard ? 12 : 8, // ← ROUNDED TOP CORNERS for first card
                bottomLeadingRadius: 8,               // Always rounded bottom corners
                bottomTrailingRadius: 8,              // Always rounded bottom corners
                topTrailingRadius: isTopCard ? 12 : 8 // ← ROUNDED TOP CORNERS for first card
            )
        )
        // MARK: - Card Shadow
        /// Subtle shadow for visual depth and card elevation
        .shadow(
            color: .black.opacity(0.15),  // Transparent black for subtle shadow
            radius: 4,                    // Soft shadow spread
            x: 0,                         // No horizontal offset
            y: 2                          // Small vertical offset for floating effect
        )
    }
}
