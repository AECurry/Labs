//
//  HistoricalDataView.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import SwiftUI

struct HistoricalDataView: View {
    let data: DailyProgressData
    let useMetric: Bool
    
    // MARK: - Design Constants
    private let contentWidth: CGFloat = 360
    private let sectionSpacing: CGFloat = 24
    private let cardSpacing: CGFloat = 12
    private let headerFontSize: CGFloat = 24
    private let dateFontSize: CGFloat = 16
    
    var body: some View {
        ScrollView {
            VStack(spacing: sectionSpacing) {
                // Date Header
                VStack(spacing: 8) {
                    Text(data.formattedDate)
                        .font(.custom("Spinnaker-Regular", size: headerFontSize))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    if data.isToday {
                        Text("Today")
                            .font(.custom("Inter-SemiBold", size: dateFontSize))
                            .foregroundColor(MasukiColors.mediumJungle)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(MasukiColors.mediumJungle.opacity(0.1))
                            )
                    }
                }
                .padding(.top, 24)
                
                // Check if there's any data for this day
                if data.hasWalkingData {
                    // Historical data cards (reuse existing card components)
                    VStack(spacing: cardSpacing) {
                        // Timeline Card
                        TodayTimelineCard(
                            sessions: data.sessions,
                            isHealthKitEnabled: true
                        )
                        
                        // Stats Card
                        TodayStatsCard(
                            activeTime: data.totalActiveTime,
                            calories: data.totalCalories,
                            miles: data.totalDistance,
                            isHealthKitEnabled: true,
                            useMetric: useMetric
                        )
                        
                        // Streak Card (showing streak status on that day)
                        TodayStreakCard(
                            currentStreak: data.currentStreak,
                            longestStreak: data.longestStreak
                        )
                        
                        // Badges Card (showing badges earned by that day)
                        TodayBadgesCard(badgesEarned: data.badgesEarned)
                        
                        // Show any new badges unlocked that day
                        if !data.newBadgesUnlocked.isEmpty {
                            NewBadgesUnlockedCard(badgeTitles: data.newBadgesUnlocked)
                        }
                    }
                } else {
                    // No data for this day
                    NoDataView(date: data.date)
                }
                
                Spacer(minLength: 100)
            }
            .frame(width: contentWidth)
        }
    }
}

// MARK: - No Data View
private struct NoDataView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 60))
                .foregroundColor(MasukiColors.coffeeBean.opacity(0.3))
            
            Text("No walks recorded")
                .font(.custom("Spinnaker-Regular", size: 20))
                .foregroundColor(MasukiColors.adaptiveText)
            
            Text("You didn't walk on this day")
                .font(.custom("Inter-Regular", size: 14))
                .foregroundColor(MasukiColors.coffeeBean)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(MasukiColors.adaptiveBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(MasukiColors.coffeeBean.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - New Badges Unlocked Card
private struct NewBadgesUnlockedCard: View {
    let badgeTitles: [String]
    
    private let cardWidth: CGFloat = 360
    private let cornerRadius: CGFloat = 16
    private let padding: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(MasukiColors.mediumJungle)
                
                Text("New Badges Unlocked!")
                    .font(.custom("Inter-SemiBold", size: 18))
                    .foregroundColor(MasukiColors.adaptiveText)
            }
            
            ForEach(badgeTitles, id: \.self) { title in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(MasukiColors.mediumJungle)
                    
                    Text(title)
                        .font(.custom("Inter-Regular", size: 14))
                        .foregroundColor(MasukiColors.adaptiveText)
                }
            }
        }
        .frame(maxWidth: cardWidth)
        .padding(padding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(MasukiColors.mediumJungle.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(MasukiColors.mediumJungle.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 40) {
        // Day with data
        HistoricalDataView(
            data: DailyProgressData.sampleToday,
            useMetric: false
        )
        
        // Day without data
        HistoricalDataView(
            data: DailyProgressData.sampleEmptyDay,
            useMetric: false
        )
    }
    .background(MasukiColors.adaptiveBackground)
}

