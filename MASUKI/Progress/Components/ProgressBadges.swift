//
//  ProgressBadges.swift
//  MASUKI
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct ProgressBadges: View {
    let badges: [AchievementBadge]
    
    // Component controls its own spacing
    @AppStorage("progressBadgesTopPadding") private var topPadding: Double = 0
    @AppStorage("progressBadgesBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("progressBadgesHorizontalPadding") private var horizontalPadding: Double = 16
    
    // Internal layout
    private let titleSpacing: CGFloat = 16
    private let gridSpacing: CGFloat = 20
    private let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        VStack(alignment: .leading, spacing: titleSpacing) {
            Text("Achievements")
                .font(.custom("Spinnaker-Regular", size: 24))
                .foregroundColor(MasukiColors.adaptiveText)
            
            LazyVGrid(columns: columns, spacing: gridSpacing) {
                ForEach(badges) { badge in
                    BadgeView(badge: badge)
                }
            }
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

struct BadgeView: View {
    let badge: AchievementBadge
    
    // Internal sizing
    private let circleSize: CGFloat = 70
    private let iconSize: CGFloat = 24
    private let textSpacing: CGFloat = 8
    private let titleHeight: CGFloat = 30
    private let frameWidth: CGFloat = 100
    
    var body: some View {
        VStack(spacing: textSpacing) {
            // Badge Icon
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ?
                          MasukiColors.mediumJungle.opacity(0.2) :
                          Color.gray.opacity(0.1))
                    .frame(width: circleSize, height: circleSize)
                
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
                .frame(height: titleHeight)
        }
        .frame(width: frameWidth)
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
    }
}
