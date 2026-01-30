//
//  TodaysSectionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodaysSectionView: View {
    let sessions: [TodaySession]
    let activeTime: TimeInterval
    let calories: Double
    let miles: Double
    let currentStreak: Int
    let longestStreak: Int
    let badgesEarned: Int
    let isHealthKitEnabled: Bool
    
    // Component controls its own spacing
    @AppStorage("todaySectionTopPadding") private var topPadding: Double = 32
    @AppStorage("todaySectionBottomPadding") private var bottomPadding: Double = 32
    @AppStorage("todaySectionHorizontalPadding") private var horizontalPadding: Double = 8
    @AppStorage("todaySectionCardSpacing") private var cardSpacing: Double = 24
    @AppStorage("todaySectionTitleSpacing") private var titleSpacing: Double = 24
    
    // Retrieve metric setting from MoreScreen
    @AppStorage("useMetricSystem") private var useMetric: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: titleSpacing) {
            // "Today" heading with calendar icon
            HStack {
                Text("Today")
                    .font(.custom("Spinnaker-Regular", size: 36))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            
            // Cards stack
            VStack(spacing: cardSpacing) {
                TodayTimelineCard(
                    sessions: sessions,
                    isHealthKitEnabled: isHealthKitEnabled
                )
                
                TodayStatsCard(
                    activeTime: activeTime,
                    calories: calories,
                    miles: miles,
                    isHealthKitEnabled: isHealthKitEnabled,
                    useMetric: useMetric
                )
                
                TodayStreakCard(
                    currentStreak: currentStreak,
                    longestStreak: longestStreak
                )
                
                TodayBadgesCard(badgesEarned: badgesEarned)
            }
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    TodaysSectionView(
        sessions: [
            TodaySession(
                startTime: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!,
                endTime: Calendar.current.date(bySettingHour: 9, minute: 3, second: 0, of: Date())!,
                duration: 33 * 60,
                distance: 4.2,
                calories: 1058
            )
        ],
        activeTime: 33 * 60,
        calories: 1058,
        miles: 4.2,
        currentStreak: 42,
        longestStreak: 108,
        badgesEarned: 8,
        isHealthKitEnabled: true
    )
    .background(MasukiColors.adaptiveBackground)
}
