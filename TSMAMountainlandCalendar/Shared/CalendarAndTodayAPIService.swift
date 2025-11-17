//
//  CalendarAndTodayAPIService.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/14/25.
//


import Foundation

// MARK: - CalendarAndToday API Service Protocol
/// Shared protocol/service for loading calendar and daily lesson data.
/// Used by both TodayViewModel and CalendarViewModel.
/// To update API logic, just change this file!
protocol CalendarAndTodayAPIService {
    /// Fetch lesson data for a specific date
    func fetchDailyContent(for date: Date) async throws -> CalendarEntry?

    /// Fetch all calendar entries (for calendar/month/monthly views)
    func fetchAllEntries() async throws -> [CalendarEntry]
}

// MARK: - Mock Calendar+Today API Service
/// Development/test implementation — replace with real API when available.
class MockCalendarAndTodayAPIService: CalendarAndTodayAPIService {
    func fetchDailyContent(for date: Date) async throws -> CalendarEntry? {
        try? await Task.sleep(nanoseconds: 300_000_000) // Simulate delay
        let placeholders = CalendarEntry.placeholders
        return placeholders.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func fetchAllEntries() async throws -> [CalendarEntry] {
        try? await Task.sleep(nanoseconds: 500_000_000) // Simulate delay
        return CalendarEntry.placeholders
    }
}
