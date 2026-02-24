//
//  CalendarRepository.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import Foundation

/// Repository for fetching calendar and historical data
final class CalendarRepository {
    private let healthKit = HealthKitManager.shared
    private let persistence = DataPersistenceManager.shared
    
    // MARK: - Fetch Data for Specific Date
    
    /// Fetches all progress data for a specific date
    func fetchData(for date: Date) async -> DailyProgressData {
        // Check if we have saved data for this date
        if let savedData = persistence.loadData(for: date) {
            return savedData
        }
        
        // If not saved, fetch from HealthKit (for historical dates)
        return await fetchFromHealthKit(for: date)
    }
    
    /// Fetches data from HealthKit for a specific date
    private func fetchFromHealthKit(for date: Date) async -> DailyProgressData {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch HealthKit data
        let sessions = await healthKit.getWorkouts(from: startOfDay, to: endOfDay)
        let activeTime = sessions.reduce(0) { $0 + $1.duration }
        let calories = sessions.reduce(0) { $0 + $1.calories }
        let distance = sessions.reduce(0) { $0 + $1.distance }
        
        // Get streaks and badges from UserDefaults (or calculate)
        let currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        let longestStreak = UserDefaults.standard.integer(forKey: "longestStreak")
        let badgesEarned = UserDefaults.standard.integer(forKey: "badgesEarned")
        
        return DailyProgressData(
            date: startOfDay,
            sessions: sessions,
            totalActiveTime: activeTime,
            totalCalories: calories,
            totalDistance: distance,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            badgesEarned: badgesEarned
        )
    }
    
    // MARK: - Calendar Helpers
    
    /// Gets all dates in a month that have walking data
    func getDatesWithData(in month: Date) -> Set<Date> {
        persistence.getDatesWithData(in: month)
    }
    
    /// Checks if a specific date has walking data
    func hasData(for date: Date) -> Bool {
        if let data = persistence.loadData(for: date) {
            return data.hasWalkingData
        }
        return false
    }
}

