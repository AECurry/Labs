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
    
    private let repository: ProgressRepositoryProtocol
    
    init(repository: ProgressRepositoryProtocol = ProgressRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func loadData() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        totalMiles = await repository.fetchTotalMiles()
        todayMiles = await repository.fetchTodayMiles()
        
        let streaks = await repository.fetchStreaks()
        currentStreak = streaks.current
        longestStreak = streaks.longest
        
        totalTime = await repository.fetchTotalTime()
        weeklyData = await repository.fetchWeeklyData()
    }
}
