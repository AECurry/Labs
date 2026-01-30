//
//  ProgressView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

//  Parent file for the entire Progress folder
import SwiftUI

struct ProgressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel = ProgressViewModel()
    @State private var badgeViewModel: BadgeViewModel?
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with kanji icon
                ProgressHeader()
                
                ScrollView {
                    VStack(spacing: 0) { // NO spacing - components control their own
                        
                        // Name, Badge, and Streak Section
                        ProgressBadgeSection(
                            userName: SettingsManager.shared.userName,
                            streak: viewModel.currentStreak,
                            badge: getFirstUnlockedBadge()
                        )
                        
                        // Miles/Time Counter
                        ProgressCounter(
                            totalMiles: viewModel.totalMiles,
                            totalTime: viewModel.totalTime,
                            isHealthKitEnabled: SettingsManager.shared.isHealthKitEnabled
                        )
                        
                        // NEW: Today's Stats Section (replaces old TodaySectionView)
                        TodaysSectionView(
                            sessions: viewModel.todaySessions,
                            activeTime: viewModel.todayActiveTime,
                            calories: viewModel.todayCalories,
                            miles: viewModel.todayMiles,
                            currentStreak: viewModel.currentStreak,
                            longestStreak: viewModel.longestStreak,
                            badgesEarned: viewModel.badgesEarned,
                            isHealthKitEnabled: SettingsManager.shared.isHealthKitEnabled
                        )
                        
                        // Spacer for bottom padding
                        Spacer(minLength: 100)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .task {
            await viewModel.loadData()
            badgeViewModel = BadgeViewModel(progressData: viewModel)
        }
        .refreshable {
            await viewModel.loadData()
            badgeViewModel?.refresh()
        }
    }
    
    private func getFirstUnlockedBadge() -> AchievementBadge {
        if let badgeViewModel = badgeViewModel,
           let firstUnlockedBadge = badgeViewModel.badges.first(where: { $0.isUnlocked }) {
            return firstUnlockedBadge
        }
        return createDefaultBadge()
    }
    
    private func createDefaultBadge() -> AchievementBadge {
        AchievementBadge(
            title: "Walker",
            description: "Keep going!",
            iconName: "figure.walk",
            isUnlocked: true,
            unlockDate: nil,
            requirement: "Start walking"
        )
    }
}

#Preview {
    ProgressView()
}
