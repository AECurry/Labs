//
//  ProgressBadgeSection.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

// Define a custom vertical alignment
extension VerticalAlignment {
    private enum IconAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[VerticalAlignment.center]
        }
    }
    static let iconAlignment = VerticalAlignment(IconAlignment.self)
}

struct ProgressBadgeSection: View {
    let userName: String
    let streak: Int
    let badge: AchievementBadge
    
    @State private var isFireAnimating = false
    
    // MARK: - Design Constants
    private let sectionWidth: CGFloat = 360  // ← ADD THIS for consistent width
    private let sideColumnWidth: CGFloat = 100
    private let badgeSize: CGFloat = 152
    private let iconSize: CGFloat = 24
    private let badgeIconSize: CGFloat = 60
    
    var body: some View {
        HStack(alignment: .iconAlignment, spacing: 20) {
            // Left: Name with waving hand
            VStack(spacing: 8) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: iconSize))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .alignmentGuide(.iconAlignment) { d in d[VerticalAlignment.center] }
                    .frame(width: 30, height: 30)
                
                Text(userName)
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            .frame(width: sideColumnWidth)  // ← Consistent width
            
            // Center: Badge
            ZStack {
                Circle()
                    .fill(MasukiColors.claySoil)
                    .frame(width: badgeSize, height: badgeSize)
                
                Image(systemName: badge.iconName)
                    .font(.system(size: badgeIconSize))
                    .foregroundColor(MasukiColors.mediumJungle)
            }
            .alignmentGuide(.iconAlignment) { d in d[VerticalAlignment.center] }
            
            // Right: Streak section
            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: iconSize))
                    .foregroundColor(.orange)
                    .scaleEffect(isFireAnimating ? 1.2 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                        value: isFireAnimating
                    )
                    .alignmentGuide(.iconAlignment) { d in d[VerticalAlignment.center] }
                    .frame(width: 30, height: 30)
                
                HStack(spacing: 4) {
                    Text("\(streak)")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    Text("Day")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundColor(MasukiColors.adaptiveText)
                }
                
                Text("Streak")
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            .frame(width: sideColumnWidth)  // ← Consistent width
            .onAppear {
                isFireAnimating = true
            }
        }
        .frame(width: sectionWidth)  // ← ADD THIS to constrain overall width
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
    }
}
