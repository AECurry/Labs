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
    
    @AppStorage("progressTitleFontSize") private var fontSize: Double = 64
    @AppStorage("progressSubtitleFontSize") private var subtitleFontSize: Double = 20
    
    let totalMiles: Double
    
    var body: some View {
        VStack(spacing: spacing) {
            // Big Number Display with comma formatting
            Text("\(formatMiles(totalMiles))")
                .font(.custom("Spinnaker-Regular", size: fontSize))
                .foregroundColor(MasukiColors.mediumJungle)
                .contentTransition(.numericText())
            
            // Subtitle
            Text("Miles, and counting!")
                .font(.custom("Inter-Regular", size: subtitleFontSize))
                .foregroundColor(MasukiColors.coffeeBean)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
    
    private func formatMiles(_ miles: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        
        let number = NSNumber(value: miles)
        return formatter.string(from: number) ?? "\(Int(miles))"
    }
}

#Preview {
    ProgressTitle(totalMiles: 25982.5)
}
