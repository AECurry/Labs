//
//  TimerDisplayView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct TimerDisplayView: View {
    @AppStorage("timerDisplayTopPadding") private var topPadding: Double = 0
    @AppStorage("timerDisplayBottomPadding") private var bottomPadding: Double = 16
    @AppStorage("timerDisplayHorizontalPadding") private var horizontalPadding: Double = 0
    
    @AppStorage("timerFontSize") private var timerFontSize: Double = 64
    @AppStorage("timerLabelFontSize") private var labelFontSize: Double = 18
    @AppStorage("timerSpacing") private var spacing: Double = 8
    
    let timeString: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: spacing) {
            Text(timeString)
                .font(.custom("Inter-Bold", size: timerFontSize, relativeTo: .largeTitle))
                .foregroundColor(isActive ? MasukiColors.mediumJungle : MasukiColors.coffeeBean)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: timeString)
            
            Text("Time Remaining")
                .font(.custom("Inter-Medium", size: labelFontSize))
                .foregroundColor(MasukiColors.coffeeBean)
                .opacity(0.8)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    VStack {
        TimerDisplayView(timeString: "21:00", isActive: true)
        TimerDisplayView(timeString: "05:23", isActive: false)
    }
    .background(MasukiColors.adaptiveBackground)
}

