//
//  TodayStreakCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodayStreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    
    // MARK: - Design Constants
    private let cardWidth: CGFloat = 360          // Card width
    private let cornerRadius: CGFloat = 16        // Rounded corners
    private let strokeWidth: CGFloat = 2          // Border thickness
    
    // Spacing
    private let padding: CGFloat = 16             // Card padding on all sides
    private let titleValueSpacing: CGFloat = 8    // Space between title and value
    
    // Typography
    private let titleFontSize: CGFloat = 16       // "Current Streak", "Longest Streak"
    private let valueFontSize: CGFloat = 32       // Streak number
    
    // Dividers
    private let dividerWidth: CGFloat = 1
    private let dividerHeight: CGFloat = 60
    private let dividerSpacing: CGFloat = 0       // Space on both sides of divider
    
    var body: some View {
        HStack(spacing: 0) {
            // Current Streak
            StreakColumn(
                title: "Current Streak",
                value: currentStreak,
                titleSize: titleFontSize,
                valueSize: valueFontSize,
                spacing: titleValueSpacing
            )
            
            // Divider with spacing
            Divider()
                .frame(width: dividerWidth, height: dividerHeight)
                .background(MasukiColors.adaptiveText.opacity(0.2))
                .padding(.horizontal, dividerSpacing)
            
            // Longest Streak
            StreakColumn(
                title: "Longest Streak",
                value: longestStreak,
                titleSize: titleFontSize,
                valueSize: valueFontSize,
                spacing: titleValueSpacing
            )
        }
        .padding(padding)
        .frame(width: cardWidth)
        .background(MasukiColors.adaptiveBackground.opacity(0.5))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(MasukiColors.mediumJungle.opacity(0.2), lineWidth: strokeWidth)
        )
    }
}

struct StreakColumn: View {
    let title: String
    let value: Int
    let titleSize: CGFloat
    let valueSize: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        VStack(spacing: spacing) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: titleSize))
                .foregroundColor(MasukiColors.adaptiveText)
            
            Text("\(value) days")
                .font(.custom("Inter-SemiBold", size: valueSize))
                .foregroundColor(MasukiColors.adaptiveText)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodayStreakCard(
        currentStreak: 42,
        longestStreak: 108
    )
    .padding()
    .background(MasukiColors.adaptiveBackground)
}
