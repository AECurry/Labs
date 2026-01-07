//
//  ProgressBadges.swift
//  MASUKI
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct ProgressBadges: View {
    let badges: [AchievementBadge]
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.custom("Spinnaker-Regular", size: 24))
                .foregroundColor(MasukiColors.adaptiveText)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(badges) { badge in
                    BadgeView(badge: badge)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct BadgeView: View {
    let badge: AchievementBadge
    
    var body: some View {
        VStack(spacing: 8) {
            // Badge Icon - All use mediumJungle
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ?
                          MasukiColors.mediumJungle.opacity(0.2) :
                          Color.gray.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                Image(systemName: badge.iconName)
                    .font(.title2)
                    .foregroundColor(badge.isUnlocked ?
                                    MasukiColors.mediumJungle :
                                    Color.gray.opacity(0.5))
            }
            
            // Badge Title
            Text(badge.title)
                .font(.custom("Inter-Medium", size: 12))
                .foregroundColor(badge.isUnlocked ?
                                MasukiColors.adaptiveText :
                                Color.gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 30)
        }
        .frame(width: 100)
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
    }
}
