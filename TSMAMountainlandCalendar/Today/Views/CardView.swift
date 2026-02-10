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
/// Supports different corner styles for use in various contexts (Today tab vs Calendar tab)
struct CardView: View {
    // MARK: - Card Style Enum
    /// Defines the corner rounding style for different usage contexts
    enum CardStyle {
        case topOfStack      // First card under a header (flat top) - used in Today tab
        case standalone      // Independent card (all corners rounded) - used in Calendar tab
        case stackedBelow    // Card in a stack (flat top) - used for middle cards
        
        var topCornerRadius: CGFloat {
            switch self {
            case .topOfStack, .stackedBelow:
                return 0   // Flat top for stacked appearance
            case .standalone:
                return 12  // Rounded top for standalone cards
            }
        }
    }
    
    // MARK: - Properties
    let emoji: String            // Visual icon representing card content (e.g., "📚", "👨‍🏫")
    let title: String            // Header text displayed in the colored bar
    let content: String          // Main content text in the white area
    let cardStyle: CardStyle     // Determines corner styling based on usage context
    
    // MARK: - Convenience Initializer (Backward Compatible)
    /// Maintains backward compatibility with existing code using `isTopCard: Bool`
    /// Converts old boolean parameter to new CardStyle enum
    init(emoji: String, title: String, content: String, isTopCard: Bool) {
        self.emoji = emoji
        self.title = title
        self.content = content
        // isTopCard = true means it's the first card (could be either context)
        // We default to topOfStack for backward compatibility (Today tab behavior)
        self.cardStyle = isTopCard ? .topOfStack : .stackedBelow
    }
    
    // MARK: - Primary Initializer (Preferred)
    /// Modern initializer with explicit CardStyle parameter
    /// Use this for new code to be explicit about card styling intent
    init(emoji: String, title: String, content: String, cardStyle: CardStyle = .stackedBelow) {
        self.emoji = emoji
        self.title = title
        self.content = content
        self.cardStyle = cardStyle
    }
    
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
        .frame(width: 368)        // Fixed card width for consistent layout
        
        // MARK: - Card Shape and Corners
        /// Dynamic corner rounding based on CardStyle
        /// Supports three contexts: top of stack (Today tab), standalone (Calendar tab), or stacked below
        .clipShape(
            .rect(
                topLeadingRadius: cardStyle.topCornerRadius,    // Dynamic based on style
                bottomLeadingRadius: 8,                         // Always rounded bottom corners
                bottomTrailingRadius: 8,                        // Always rounded bottom corners
                topTrailingRadius: cardStyle.topCornerRadius    // Dynamic based on style
            )
        )
        
        // MARK: - Card Shadow
        /// Enhanced shadow for more visual depth and card elevation
        .shadow(
            color: .black.opacity(0.15), // Darker shadow for stronger visual separation
            radius: 4,                   // Larger blur radius for softer shadow
            x: 0,                        // No horizontal offset
            y: 2                         // More vertical offset for pronounced floating effect
        )
    }
}

// MARK: - Preview
/// Shows all three card styles for comparison
#Preview {
    VStack(spacing: 20) {
        // Standalone card (Calendar tab style)
        CardView(
            emoji: "🌴",
            title: "Weekend",
            content: "No class today. Enjoy your weekend!",
            cardStyle: .standalone
        )
        
        // Top of stack (Today tab style)
        CardView(
            emoji: "📚",
            title: "Word of the Day",
            content: "This card sits under the date header",
            cardStyle: .topOfStack
        )
        
        // Stacked below (middle cards)
        CardView(
            emoji: "🎯",
            title: "Main Objective",
            content: "This card is in the middle of a stack",
            cardStyle: .stackedBelow
        )
    }
    .padding()
    .background(MountainlandColors.platinum)
}
