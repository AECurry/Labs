//
//  ProgressTitle.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ProgressTitle: View {
    @AppStorage("progressTitleTopPadding") private var topPadding: Double = 0
    @AppStorage("progressTitleBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("progressTitleHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("progressTitleSpacing") private var spacing: Double = 8
    
    @AppStorage("progressTitleFontSize") private var fontSize: Double = 48
    @AppStorage("progressSubtitleFontSize") private var subtitleFontSize: Double = 24
    
    let totalMiles: Double
    
    var body: some View {
        VStack(spacing: spacing) {
            // Big Number Display (like your screenshot)
            Text("\(Int(totalMiles))")
                .font(.custom("Spinnaker-Regular", size: fontSize))
                .foregroundColor(MasukiColors.mediumJungle)
            
            // Subtitle
            Text("Miles, and counting!")
                .font(.custom("Inter-Regular", size: subtitleFontSize))
                .foregroundColor(MasukiColors.coffeeBean)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}
