//
//  DataPersistenceManager.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import Foundation

/// Manages saving and loading daily progress data
final class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    private let userDefaults = UserDefaults.standard
    private let dailyDataKey = "dailyProgressHistory"
    
    private init() {}
    
    // MARK: - Save Daily Data
    
    /// Saves today's progress data
    func saveTodayProgress(_ data: DailyProgressData) {
        var history = loadAllHistory()
        
        // Remove any existing entry for today (in case we're updating)
        history.removeAll { Calendar.current.isDate($0.date, inSameDayAs: data.date) }
        
        // Add new entry
        history.append(data)
        
        // Sort by date (newest first)
        history.sort { $0.date > $1.date }
        
        // Keep only last 365 days (1 year)
        let oneYearAgo = Calendar.current.date(byAdding: .day, value: -365, to: Date())!
        history = history.filter { $0.date >= oneYearAgo }
        
        // Save to UserDefaults
        saveHistory(history)
        
        print("Saved progress for: \(data.formattedDate)")
    }
    
    /// Automatically saves current state at midnight
    func saveCurrentStateAsToday(from viewModel: ProgressViewModel) {
        let todayData = DailyProgressData.fromCurrentState(
            sessions: viewModel.todaySessions,
            activeTime: viewModel.todayActiveTime,
            calories: viewModel.todayCalories,
            distance: viewModel.todayMiles,
            currentStreak: viewModel.currentStreak,
            longestStreak: viewModel.longestStreak,
            badgesEarned: viewModel.badgesEarned
        )
        
        saveTodayProgress(todayData)
    }
    
    // MARK: - Load Data
    
    /// Loads progress data for a specific date
    func loadData(for date: Date) -> DailyProgressData? {
        let history = loadAllHistory()
        return history.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    /// Loads all historical data
    func loadAllHistory() -> [DailyProgressData] {
        guard let data = userDefaults.data(forKey: dailyDataKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([DailyProgressData].self, from: data)
        } catch {
            print("Error loading history: \(error)")
            return []
        }
    }
    
    /// Gets dates that have walking data (for calendar indicators)
    func getDatesWithData(in month: Date) -> Set<Date> {
        let history = loadAllHistory()
        let calendar = Calendar.current
        
        return Set(history
            .filter { data in
                calendar.isDate(data.date, equalTo: month, toGranularity: .month) &&
                data.hasWalkingData
            }
            .map { calendar.startOfDay(for: $0.date) }
        )
    }
    
    // MARK: - Private Helpers
    
    private func saveHistory(_ history: [DailyProgressData]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(history)
            userDefaults.set(data, forKey: dailyDataKey)
        } catch {
            print("Error saving history: \(error)")
        }
    }
    
    // MARK: - Clear Data (for testing)
    
    func clearAllHistory() {
        userDefaults.removeObject(forKey: dailyDataKey)
        print("Cleared all history")
    }
}

