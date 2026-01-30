//
//  WalkSessionHeader.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionHeader: View {
    @AppStorage("walkSessionHeaderTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSessionHeaderBottomPadding") private var bottomPadding: Double = 8
    @AppStorage("walkSessionHeaderHorizontalPadding") private var horizontalPadding: Double = 16
    @AppStorage("walkSessionHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("walkSessionHeaderIconPadding") private var iconPadding: Double = 12
    
    // Back button action passed from parent
    let onBack: () -> Void
    
    var body: some View {
        HStack {
            // Back Button (left side)
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(MasukiColors.carbonBlack)
                    .padding(iconPadding)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Masuki/Kanji Icon (right side) - Display only
            Image("KanjiMatsukiIcon")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .padding(iconPadding)
                .opacity(0.8)
        }
        .frame(height: 44)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    WalkSessionHeader(onBack: {})
        .background(MasukiColors.adaptiveBackground)
}
