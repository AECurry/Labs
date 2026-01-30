//
//  TodayViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation
import Observation

/// TodayViewModel: Provides lesson data for the current/selected day.
/// Uses the real APIController to fetch daily lesson content from the server.
@Observable
class TodayViewModel {
    // MARK: - Published Properties
    var dailyContent: CalendarEntry?
    var date: Date {
        didSet {
            // Clear content when date changes to show loading state
            if !Calendar.current.isDate(oldValue, inSameDayAs: date) {
                dailyContent = nil
            }
        }
    }
    var isLoading = false
    var error: String?

    // MARK: - Dependency (Real API Controller)
    private let apiService: CalendarAndTodayAPIService

    // MARK: - Initialization
    /// Initialize with today's date (default) or a specific date.
    /// Uses real API controller unless a custom service is provided for testing.
    init(date: Date = Date(),
         apiService: CalendarAndTodayAPIService = APIController.shared) {
        self.date = date
        self.apiService = apiService
        self.dailyContent = nil
    }

    // MARK: - Data Loading
    /// Fetches the lesson plan for the current date from the server.
    /// This powers the Today tab with all lesson details.
    func loadDailyContent() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            dailyContent = try await apiService.fetchDailyContent(for: date)
            
            // If no content returned, it means no lesson scheduled for this day
            if dailyContent == nil {
                self.error = "No lesson scheduled for this day"
            }
        } catch let apiError as APIError {
            // Handle specific API errors with helpful messages
            switch apiError {
            case .unauthorized:
                self.error = "Please log in to view today's lesson"
            case .networkError:
                self.error = "No internet connection. Please check your network."
            case .invalidResponse, .statusCode:
                self.error = "Server error. Please try again later."
            default:
                self.error = "Failed to load daily content: \(apiError.localizedDescription)"
            }
        } catch {
            self.error = "Failed to load daily content: \(error.localizedDescription)"
        }
    }

    /// Loads lesson content for a specific date.
    /// This is useful when the user navigates to a different day from the calendar.
    func loadDailyContent(for date: Date) async {
        self.date = date
        await loadDailyContent()
    }
}
