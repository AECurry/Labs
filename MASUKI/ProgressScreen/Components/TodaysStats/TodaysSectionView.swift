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
    
    // MARK: - Design Constants
    
    // Card Width (Must match card width in TodayStatsCard)
    private let cardWidth: CGFloat = 360          // Same as card width
    
    // Section Spacing
    private let topPadding: CGFloat = 72          // Space above "Today" title
    private let bottomPadding: CGFloat = 32       // Space below last card
    
    // Card Spacing
    private let cardSpacing: CGFloat = 24         // Space between cards
    private let titleSpacing: CGFloat = 24        // Space between title and first card
    
    // Typography
    private let titleFontSize: CGFloat = 36       // "Today" title size
    
    // Calendar Icon
    private let calendarIconSize: CGFloat = 24    // Calendar icon size
    
    // Retrieve metric setting from MoreScreen
    @AppStorage("useMetricSystem") private var useMetric: Bool = false
    
    var body: some View {
        VStack(spacing: titleSpacing) {
            // "Today" heading with calendar icon - constrained to card width
            HStack {
                Text("Today")
                    .font(.custom("Spinnaker-Regular", size: titleFontSize))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Spacer()
                
                Image(systemName: "calendar")
                    .font(.system(size: calendarIconSize))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            .frame(width: cardWidth)  // ← This keeps "Today" and "calendar" alinged with the cards
            
            // Cards stack - all centered
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
        .frame(maxWidth: .infinity)  // ← Centers the entire stack
    }
}

#Preview {
    TodaysSectionView(
        sessions: [
            TodaySession(
                id: UUID(),
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

