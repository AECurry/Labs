//
//  TodayViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//


import Foundation
import Observation
// Uses CalendarAndTodayAPIService from Shared/Services/CalendarAndTodayAPIService.swift

/// TodayViewModel: Provides lesson data for the current/selected day.
/// Shared API logic lives in CalendarAndTodayAPIService (see Shared/Services).
@Observable
class TodayViewModel {
    // MARK: - Published Properties
    var dailyContent: CalendarEntry?
    var date: Date {
        didSet {
            if !Calendar.current.isDate(oldValue, inSameDayAs: date) {
                dailyContent = nil
            }
        }
    }
    var isLoading = false
    var error: String?

    // MARK: - Dependency (from Shared)
    private let apiService: CalendarAndTodayAPIService

    // MARK: - Initialization
    init(date: Date = Date(),
         apiService: CalendarAndTodayAPIService = MockCalendarAndTodayAPIService()) {
        self.date = date
        self.apiService = apiService
        self.dailyContent = nil
    }

    // MARK: - Data Loading
    func loadDailyContent() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            dailyContent = try await apiService.fetchDailyContent(for: date)
        } catch {
            self.error = "Failed to load daily content: \(error.localizedDescription)"
        }
    }

    func loadDailyContent(for date: Date) async {
        self.date = date
        await loadDailyContent()
    }
}

