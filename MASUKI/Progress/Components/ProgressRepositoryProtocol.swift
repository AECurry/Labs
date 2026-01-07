//
//  ProgressRepositoryProtocol.swift
//  MASUKI
//
//  Created by AnnElaine on 1/5/26.
//

import Foundation

protocol ProgressRepositoryProtocol {
    func fetchTotalMiles() async -> Double
    func fetchTodayMiles() async -> Double
    func fetchWeeklyData() async -> [DailyDistance]
    func fetchStreaks() async -> StreakData
    func fetchTotalTime() async -> TimeInterval
}

struct StreakData {
    let current: Int
    let longest: Int
}

final class ProgressRepository: ProgressRepositoryProtocol {
    private let healthKit = HealthKitManager.shared
    
    func fetchTotalMiles() async -> Double {
        await healthKit.getAllTimeDistance()
    }
    
    func fetchTodayMiles() async -> Double {
        await healthKit.getTodayDistance()
    }
    
    func fetchWeeklyData() async -> [DailyDistance] {
        await healthKit.getWeeklyDistances()
    }
    
    func fetchStreaks() async -> StreakData {
        let current = UserDefaults.standard.integer(forKey: "currentStreak")
        let longest = UserDefaults.standard.integer(forKey: "longestStreak")
        return StreakData(current: current, longest: longest)
    }
    
    func fetchTotalTime() async -> TimeInterval {
        UserDefaults.standard.double(forKey: "totalTime")
    }
}
