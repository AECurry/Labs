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
    
    // Card styling
    private let cornerRadius: CGFloat = 16
    private let padding: CGFloat = 16
    private let strokeWidth: CGFloat = 1
    
    var body: some View {
        HStack(spacing: 0) {
            // Current Streak
            StreakColumn(
                title: "Current Streak",
                value: currentStreak
            )
            
            Divider()
                .frame(height: 60)
                .background(MasukiColors.adaptiveText.opacity(0.2))
            
            // Longest Streak
            StreakColumn(
                title: "Longest Streak",
                value: longestStreak
            )
        }
        .padding(padding)
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
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: 16))
                .foregroundColor(MasukiColors.adaptiveText)
            
            Text("\(value) days")
                .font(.custom("Inter-SemiBold", size: 32))
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
