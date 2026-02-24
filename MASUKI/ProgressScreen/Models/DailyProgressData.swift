//
//  DailyProgressData.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import Foundation

/// Represents all progress data for a single day
struct DailyProgressData: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    
    // Session data
    let sessions: [TodaySession]
    let totalActiveTime: TimeInterval
    let totalCalories: Double
    let totalDistance: Double
    
    // Streaks (snapshot for that day)
    let currentStreak: Int
    let longestStreak: Int
    
    // Badges (snapshot for that day)
    let badgesEarned: Int
    let newBadgesUnlocked: [String]  // Badge titles unlocked that day
    
    // Computed properties
    var hasWalkingData: Bool {
        !sessions.isEmpty || totalActiveTime > 0 || totalDistance > 0
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    // Initializer
    init(
        id: UUID = UUID(),
        date: Date,
        sessions: [TodaySession] = [],
        totalActiveTime: TimeInterval = 0,
        totalCalories: Double = 0,
        totalDistance: Double = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        badgesEarned: Int = 0,
        newBadgesUnlocked: [String] = []
    ) {
        self.id = id
        self.date = date
        self.sessions = sessions
        self.totalActiveTime = totalActiveTime
        self.totalCalories = totalCalories
        self.totalDistance = totalDistance
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.badgesEarned = badgesEarned
        self.newBadgesUnlocked = newBadgesUnlocked
    }
    
    // Create from current ProgressViewModel state
    static func fromCurrentState(
        date: Date = Date(),
        sessions: [TodaySession],
        activeTime: TimeInterval,
        calories: Double,
        distance: Double,
        currentStreak: Int,
        longestStreak: Int,
        badgesEarned: Int
    ) -> DailyProgressData {
        DailyProgressData(
            date: Calendar.current.startOfDay(for: date),
            sessions: sessions,
            totalActiveTime: activeTime,
            totalCalories: calories,
            totalDistance: distance,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            badgesEarned: badgesEarned
        )
    }
}

// MARK: - Sample Data for Previews
extension DailyProgressData {
    static var sampleToday: DailyProgressData {
        DailyProgressData(
            date: Date(),
            sessions: [
                TodaySession(
                    id: UUID(),  // ← ADDED
                    startTime: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!,
                    endTime: Calendar.current.date(bySettingHour: 9, minute: 3, second: 0, of: Date())!,
                    duration: 33 * 60,
                    distance: 4.2,
                    calories: 1058
                )
            ],
            totalActiveTime: 33 * 60,
            totalCalories: 1058,
            totalDistance: 4.2,
            currentStreak: 42,
            longestStreak: 108,
            badgesEarned: 8
        )
    }
    
    static var sampleYesterday: DailyProgressData {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return DailyProgressData(
            date: yesterday,
            sessions: [
                TodaySession(
                    id: UUID(),  // ← ADDED
                    startTime: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: yesterday)!,
                    endTime: Calendar.current.date(bySettingHour: 7, minute: 21, second: 0, of: yesterday)!,
                    duration: 21 * 60,
                    distance: 2.5,
                    calories: 650
                )
            ],
            totalActiveTime: 21 * 60,
            totalCalories: 650,
            totalDistance: 2.5,
            currentStreak: 41,
            longestStreak: 108,
            badgesEarned: 7
        )
    }
    
    static var sampleEmptyDay: DailyProgressData {
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        return DailyProgressData(
            date: twoDaysAgo,
            currentStreak: 40,
            longestStreak: 108,
            badgesEarned: 7
        )
    }
}

