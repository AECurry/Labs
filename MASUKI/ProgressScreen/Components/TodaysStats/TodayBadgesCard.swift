//
//  TodayBadgesCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodayBadgesCard: View {
    let badgesEarned: Int
    
    // Card styling
    private let cornerRadius: CGFloat = 16
    private let padding: CGFloat = 16
    private let strokeWidth: CGFloat = 1
    private let trophySize: CGFloat = 56
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Badges Earned")
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Text("\(badgesEarned)")
                    .font(.custom("Inter-SemiBold", size: 48))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            
            Spacer()
            
            // Trophy icon
            ZStack {
                Circle()
                    .fill(MasukiColors.mediumJungle)
                    .frame(width: trophySize, height: trophySize)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
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

#Preview {
    TodayBadgesCard(badgesEarned: 8)
        .padding()
        .background(MasukiColors.adaptiveBackground)
}
