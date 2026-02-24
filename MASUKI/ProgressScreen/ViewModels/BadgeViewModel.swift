//
//  BadgeViewModel.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import Foundation
import Observation

@Observable
class BadgeViewModel {
    var badges: [AchievementBadge] = []
    var unlockedCount: Int = 0
    var totalCount: Int = 0
    
    private let progressData: ProgressViewModel
    
    init(progressData: ProgressViewModel) {
        self.progressData = progressData
        loadBadges()
    }
    
    private func loadBadges() {
        badges = [
            // Distance Badges
            AchievementBadge(
                title: "First Steps",
                description: "Complete your first walk",
                iconName: "figure.walk",
                isUnlocked: progressData.totalMiles > 0,
                unlockDate: nil,
                requirement: "Walk any distance"
            ),
            
            AchievementBadge(
                title: "5 Miles",
                description: "Walk 5 total miles",
                iconName: "flag.fill",
                isUnlocked: progressData.totalMiles >= 5,
                unlockDate: nil,
                requirement: "5 total miles"
            ),
            
            AchievementBadge(
                title: "Marathon",
                description: "Walk 26.2 miles",
                iconName: "trophy.fill",
                isUnlocked: progressData.totalMiles >= 26.2,
                unlockDate: nil,
                requirement: "26.2 total miles"
            ),
            
            // Streak Badges
            AchievementBadge(
                title: "3 Day Streak",
                description: "Walk 3 days in a row",
                iconName: "flame.fill",
                isUnlocked: progressData.currentStreak >= 3,
                unlockDate: nil,
                requirement: "3 consecutive days"
            ),
            
            AchievementBadge(
                title: "Weekly Warrior",
                description: "Walk 7 days straight",
                iconName: "crown.fill",
                isUnlocked: progressData.currentStreak >= 7,
                unlockDate: nil,
                requirement: "7 consecutive days"
            ),
            
            // Consistency Badges
            AchievementBadge(
                title: "Early Bird",
                description: "Walk before 8 AM",
                iconName: "sunrise.fill",
                isUnlocked: false,
                unlockDate: nil,
                requirement: "Walk before 8:00 AM"
            ),
            
            AchievementBadge(
                title: "Weekend Walker",
                description: "Walk both weekend days",
                iconName: "calendar",
                isUnlocked: false,
                unlockDate: nil,
                requirement: "Walk Saturday & Sunday"
            ),
            
            AchievementBadge(
                title: "100 Miles",
                description: "Reach 100 total miles",
                iconName: "star.fill",
                isUnlocked: progressData.totalMiles >= 100,
                unlockDate: nil,
                requirement: "100 total miles"
            )
        ]
        
        unlockedCount = badges.filter { $0.isUnlocked }.count
        totalCount = badges.count
    }
    
    func refresh() {
        loadBadges()
    }
}

