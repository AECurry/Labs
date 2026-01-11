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
                // Header with back button and kanji icon
                ProgressHeader()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Name and Streak Section (using ProgressBadgeSection)
                        ProgressBadgeSection(
                            userName: SettingsManager.shared.userName, // Get from settings
                            streak: viewModel.currentStreak,
                            badge: getFirstUnlockedBadge()
                        )
                        
                        // Big Miles Counter (using ProgressTitle)
                        ProgressTitle(totalMiles: viewModel.totalMiles)
                        
                        // Today Section (using TodaySectionView)
                        TodaySectionView(todayMiles: viewModel.todayMiles)
                        
                        // Spacer for bottom padding
                        Spacer(minLength: 100)
                    }
                    .padding(.bottom, 40)
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
