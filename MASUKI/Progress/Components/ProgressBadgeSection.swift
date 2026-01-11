//
//  ProgressBadgeSection.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct ProgressBadgeSection: View {
    let userName: String
    let streak: Int
    let badge: AchievementBadge
    
    @State private var isFireAnimating = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Left: Name with waving hand
            VStack(alignment: .leading, spacing: 8) {
                VStack(spacing: 6) {
                    Image(systemName: "hand.wave.fill")
                        .font(.title2)
                        .foregroundColor(MasukiColors.mediumJungle)
                    Text(userName)
                        .font(.custom("Inter-SemiBold", size: 18))
                        .foregroundColor(MasukiColors.adaptiveText)
                }
            }
            .frame(width: 100, alignment: .leading)
            
            // Center: Badge at 152x152
            ZStack {
                Circle()
                    .fill(MasukiColors.claySoil)
                    .frame(width: 152, height: 152)
                
                Image(systemName: badge.iconName)
                    .font(.system(size: 60))
                    .foregroundColor(MasukiColors.mediumJungle)
            }
            .padding(.vertical, 8)
            
            // Right: Streak section with two-line text
            VStack(spacing: 4) {
                // Top row: Number + Fire icon
                HStack(spacing: 4) {
                    Text("\(streak)")
                        .font(.custom("Inter-SemiBold", size: 18))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .scaleEffect(isFireAnimating ? 1.2 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isFireAnimating
                        )
                }
                
                // Two lines of text
                Text("Day")
                    .font(.custom("Inter-SemiBold", size: 14))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Text("Streak")
                    .font(.custom("Inter-Regular", size: 12))
                    .foregroundColor(MasukiColors.adaptiveText.opacity(0.7))
            }
                .frame(width: 80, alignment: .trailing)
                .onAppear {
                    isFireAnimating = true
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

// THIS MUST BE OUTSIDE THE STRUCT - AT FILE LEVEL
#Preview {
    ProgressBadgeSection(
        userName: "Walker",
        streak: 25,
        badge: AchievementBadge(
            title: "Walker",
            description: "Keep going!",
            iconName: "figure.walk",
            isUnlocked: true,
            unlockDate: nil,
            requirement: "Start walking"
        )
    )
    .background(MasukiColors.adaptiveBackground)
}
