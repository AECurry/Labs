//
//  ProgressCounter.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ProgressCounter: View {
    @AppStorage("progressCounterTopPadding") private var topPadding: Double = 16
    @AppStorage("progressCounterBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("progressCounterHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("progressCounterSpacing") private var spacing: Double = 8
    @AppStorage("progressCounterFontSize") private var fontSize: Double = 80
    @AppStorage("progressCounterSubtitleFontSize") private var subtitleFontSize: Double = 24
    
    
    // MARK: - Design Constants (ADD THIS SECTION)
    private let cardWidth: CGFloat = 360  // <- Consistent width
    
    let totalMiles: Double
    let totalTime: TimeInterval
    let isHealthKitEnabled: Bool
    
    var body: some View {
        VStack(spacing: spacing) {
            // Big Number Display
            if isHealthKitEnabled {
                // Show miles when HealthKit is enabled
                Text("\(formatMiles(totalMiles))")
                    .font(.custom("Spinnaker-Regular", size: fontSize))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .contentTransition(.numericText())
                    .multilineTextAlignment(.center)  // ← ADD THIS LINE
                    .frame(maxWidth: .infinity)       // ← ADD THIS LINE
                
                Text("Miles, and counting!")
                    .font(.custom("Inter-Regular", size: subtitleFontSize))
                    .foregroundColor(MasukiColors.carbonBlack)
                    .multilineTextAlignment(.center)  // ← ADD THIS LINE
                    .frame(maxWidth: .infinity)       // ← ADD THIS LINE
            } else {
                // Show time when HealthKit is disabled
                Text("\(formatTime(totalTime))")
                    .font(.custom("Spinnaker-Regular", size: fontSize))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .contentTransition(.numericText())
                    .multilineTextAlignment(.center)  // ← ADD THIS LINE
                    .frame(maxWidth: .infinity)       // ← ADD THIS LINE
                
                Text("Minutes, and counting!")
                    .font(.custom("Inter-Regular", size: subtitleFontSize))
                    .foregroundColor(MasukiColors.carbonBlack)
                    .multilineTextAlignment(.center)  // ← ADD THIS LINE
                    .frame(maxWidth: .infinity)       // ← ADD THIS LINE
            }
        }
        .frame(width: cardWidth)  // ← ADD THIS LINE to constrain width
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
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval / 60)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        let number = NSNumber(value: minutes)
        return formatter.string(from: number) ?? "\(minutes)"
    }
}

#Preview {
    VStack(spacing: 0) { // No spacing in preview either
        ProgressCounter(
            totalMiles: 25982.5,
            totalTime: 3600,
            isHealthKitEnabled: true
        )
        
        ProgressCounter(
            totalMiles: 0,
            totalTime: 125600,
            isHealthKitEnabled: false
        )
    }
    .background(MasukiColors.adaptiveBackground)
}

