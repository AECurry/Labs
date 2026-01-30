//
//  CalendarViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

// Views/Calendar/CalendarViewModel.swift

import Foundation
import Observation

/// CalendarViewModel: Provides calendar/month schedule data.
/// Uses the real APIController to fetch calendar entries from the server.
@Observable
class CalendarViewModel {
    // MARK: - Published Properties
    var calendarEntries: [CalendarEntry] = []
    var isLoading = false
    var error: String?

    // MARK: - Dependency (Real API Controller)
    private let apiService: CalendarAndTodayAPIService

    // MARK: - Initialization
    /// Initialize with real API controller (default) or custom service for testing
    init(apiService: CalendarAndTodayAPIService = APIController.shared) {
        self.apiService = apiService
    }

    // MARK: - Data Loading
    /// Fetches all calendar entries for the academic year from the server.
    /// This populates the monthly calendar view with lesson days.
    func loadCalendarData() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            calendarEntries = try await apiService.fetchAllEntries()
        } catch let apiError as APIError {
            // Handle specific API errors with helpful messages
            switch apiError {
            case .unauthorized:
                self.error = "Please log in to view the calendar"
            case .networkError:
                self.error = "No internet connection. Please check your network."
            case .invalidResponse, .statusCode:
                self.error = "Server error. Please try again later."
            default:
                self.error = "Failed to load calendar: \(apiError.localizedDescription)"
            }
        } catch {
            self.error = "Failed to load calendar entries: \(error.localizedDescription)"
        }
    }
}
