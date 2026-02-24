//
//  ProgressViewModel.swift
//  MASUKI
//
//  Created by AnnElaine on 1/5/26.
//

import Foundation
import Observation

@Observable
final class ProgressViewModel {
    var totalMiles: Double = 0.0
    var todayMiles: Double = 0.0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var totalTime: TimeInterval = 0
    var weeklyData: [DailyDistance] = []
    var isLoading = false
    var showHealthKitPrompt = false
    
    // NEW: Today's detailed stats
    var todaySessions: [TodaySession] = []
    var todayActiveTime: TimeInterval = 0
    var todayCalories: Double = 0
    var badgesEarned: Int = 0
    
    private let repository: ProgressRepositoryProtocol
    private let settingsManager = SettingsManager.shared
    
    init(repository: ProgressRepositoryProtocol = ProgressRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func loadData() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        // Check HealthKit settings
        guard settingsManager.isHealthKitEnabled else {
            showHealthKitPrompt = true
            // Still load non-HealthKit data
            await loadNonHealthKitData()
            return
        }
        
        // Load actual data
        await loadHealthKitData()
    }
    
    @MainActor
    private func loadHealthKitData() async {
        totalMiles = await repository.fetchTotalMiles()
        todayMiles = await repository.fetchTodayMiles()
        
        let streaks = await repository.fetchStreaks()
        currentStreak = streaks.current
        longestStreak = streaks.longest
        
        totalTime = await repository.fetchTotalTime()
        weeklyData = await repository.fetchWeeklyData()
        
        // NEW: Load today's detailed data
        todaySessions = await repository.fetchTodaySessions()
        todayActiveTime = await repository.fetchTodayActiveTime()
        todayCalories = await repository.fetchTodayCalories()
        badgesEarned = await repository.fetchBadgesEarned()
        
        showHealthKitPrompt = false
    }
    
    @MainActor
    private func loadNonHealthKitData() async {
        // Load data that doesn't require HealthKit
        let streaks = await repository.fetchStreaks()
        currentStreak = streaks.current
        longestStreak = streaks.longest
        
        totalTime = await repository.fetchTotalTime()
        todayActiveTime = await repository.fetchTodayActiveTime()
        badgesEarned = await repository.fetchBadgesEarned()
    }
    
    func enableHealthKit() {
        settingsManager.isHealthKitEnabled = true
        showHealthKitPrompt = false
    }
}

