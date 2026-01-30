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
    
    var body: some View {
        HStack(alignment: .iconAlignment, spacing: 20) {
            // Left: Name with waving hand
            VStack(spacing: 8) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 24))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .alignmentGuide(.iconAlignment) { d in d[VerticalAlignment.center] }
                    .frame(width: 30, height: 30)
                
                Text(userName)
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            .frame(width: 100)
            
            // Center: Badge
            ZStack {
                Circle()
                    .fill(MasukiColors.claySoil)
                    .frame(width: 152, height: 152)
                
                Image(systemName: badge.iconName)
                    .font(.system(size: 60))
                    .foregroundColor(MasukiColors.mediumJungle)
            }
            .alignmentGuide(.iconAlignment) { d in d[VerticalAlignment.center] }
            
            // Right: Streak section
            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 24))
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
            .frame(width: 100)
            .onAppear {
                isFireAnimating = true
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
    }
}
