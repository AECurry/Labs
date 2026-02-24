//
//  TodayBadgesCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodayBadgesCard: View {
    let badgesEarned: Int
    
    // MARK: - Design Constants
    private let cardWidth: CGFloat = 360          // Card width
    private let cornerRadius: CGFloat = 16        // Rounded corners
    private let strokeWidth: CGFloat = 2          // Border thickness
    
    // Spacing
    private let padding: CGFloat = 16             // Card padding on all sides
    private let titleValueSpacing: CGFloat = 8    // Space between "Badges Earned" and number
    
    // Typography
    private let titleFontSize: CGFloat = 16       // "Badges Earned"
    private let valueFontSize: CGFloat = 48       // Badge count number
    
    // Trophy Icon
    private let trophySize: CGFloat = 56          // Size of trophy circle
    private let trophyIconSize: CGFloat = 28      // Size of trophy icon
    private let trophyPadding: CGFloat = 0        // Space between text and trophy
    
    var body: some View {
        HStack(spacing: trophyPadding) {
            VStack(alignment: .leading, spacing: titleValueSpacing) {
                Text("Badges Earned")
                    .font(.custom("Inter-SemiBold", size: titleFontSize))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Text("\(badgesEarned)")
                    .font(.custom("Inter-SemiBold", size: valueFontSize))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            
            Spacer()
            
            // Trophy icon
            ZStack {
                Circle()
                    .fill(MasukiColors.mediumJungle)
                    .frame(width: trophySize, height: trophySize)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: trophyIconSize))
                    .foregroundColor(.white)
            }
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

#Preview {
    TodayBadgesCard(badgesEarned: 8)
        .padding()
        .background(MasukiColors.adaptiveBackground)
}

