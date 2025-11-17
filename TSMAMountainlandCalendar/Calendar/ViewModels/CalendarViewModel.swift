//
//  CalendarViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

// Views/Calendar/CalendarViewModel.swift

import Foundation
import Observation
// Uses CalendarAndTodayAPIService from Shared/Services/CalendarAndTodayAPIService.swift

/// CalendarViewModel: Provides calendar/month schedule data.
/// Shared API logic lives in CalendarAndTodayAPIService (see Shared/Services).
@Observable
class CalendarViewModel {
    // MARK: - Published Properties
    var calendarEntries: [CalendarEntry] = []
    var isLoading = false
    var error: String?

    // MARK: - Dependency (from Shared)
    private let apiService: CalendarAndTodayAPIService

    // MARK: - Initialization
    init(apiService: CalendarAndTodayAPIService = MockCalendarAndTodayAPIService()) {
        self.apiService = apiService
    }

    // MARK: - Data Loading
    func loadCalendarData() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            calendarEntries = try await apiService.fetchAllEntries()
        } catch {
            self.error = "Failed to load calendar entries: \(error.localizedDescription)"
        }
    }
}
