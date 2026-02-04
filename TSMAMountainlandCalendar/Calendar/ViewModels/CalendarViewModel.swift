//
//  CalendarViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation
import Observation

// MARK: - Calendar ViewModel
/// Comprehensive ViewModel responsible for managing academic calendar data and monthly schedule information
/// Provides calendar entries for month views and handles date-based content retrieval from API
/// Serves as the data management layer between CalendarView UI and APIController backend services
/// Implements the @Observable protocol for reactive state management with SwiftUI
/// Follows SOLID principles with single responsibility for calendar data operations
@Observable
class CalendarViewModel {
    // MARK: - State Properties
    
    /// Array of calendar entries representing instructional days for the complete academic term
    /// Contains comprehensive lesson data, assignments, holidays, and daily educational components
    /// Empty array indicates no data loaded, loading in progress, or API communication failure
    /// Automatically triggers UI re-rendering when modified through @Observable property observation
    var calendarEntries: [CalendarEntry] = []
    
    /// Loading state indicator for asynchronous calendar data operations
    /// Controls UI presentation of progress indicators, loading overlays, and skeleton screens
    /// Set to true during API data retrieval and automatically reset upon completion
    /// Ensures responsive user feedback during potentially long-running network operations
    var isLoading = false
    
    /// User-friendly error message for display when calendar data loading operations fail
    /// Provides actionable feedback for authentication issues, network problems, or server errors
    /// Cleared automatically when new loading operations begin to prevent stale error states
    /// Supports localization for international user bases with appropriate error messaging
    var errorMessage: String?

    // MARK: - Primary Data Loading Method
    
    /// Asynchronously loads all calendar entries for the academic term from the API server
    /// Fetches comprehensive calendar data including holidays, lessons, assignments, and special events
    /// Manages complete API communication lifecycle with authentication, error handling, and state updates
    /// Should be called when CalendarView appears or when academic term changes occur
    /// Implements proper Swift Concurrency patterns with MainActor coordination for thread safety
    func loadCalendarData() async {
        // Verify user authentication before attempting API request
        // Prevents unauthorized access attempts and provides appropriate user guidance
        // Leverages APIController's centralized authentication state management
        guard APIController.shared.isAuthenticated else {
            await MainActor.run {
                errorMessage = "Please log in to view the calendar"
            }
            return
        }
        
        // Set loading state to true to trigger UI loading indicators
        // Must update @Observable properties on MainActor for proper thread safety
        // Ensures immediate visual feedback when data loading begins
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Ensure loading state is reset regardless of success or failure
        // Uses defer block for guaranteed cleanup to prevent perpetual loading UI states
        // Implements Task with @MainActor decorator for safe main thread execution
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            // Fetch all calendar entries from the API server for the current cohort
            // Uses APIController's fetchAllCalendarEntries method for standardized API communication
            // Executes network request on background thread via Swift Concurrency automatically
            // Implements proper timeout and retry configurations through URLSession
            let response = try await APIController.shared.fetchAllCalendarEntries()
            
            // Convert API DTO responses to internal CalendarEntry models
            // Uses CalendarEntry initializer for consistent data transformation across the app
            // Handles optional values, type conversions, and data validation with appropriate defaults
            let entries = response.map { CalendarEntry(from: $0) }
            
            // Update UI with loaded calendar entries on MainActor for thread safety
            // @Observable properties require main thread updates for proper UI synchronization
            // Triggers automatic SwiftUI view updates through property observation system
            await MainActor.run {
                calendarEntries = entries
            }
            
        } catch let apiError {
            // Handle and store error for UI display on MainActor
            // Transforms technical API errors into user-friendly localized messages
            // Provides error categorization for better troubleshooting and user guidance
            await MainActor.run {
                errorMessage = handleAPIError(apiError)
            }
        }
    }
    
    // MARK: - Error Handling Utility Method
    
    /// Transforms raw API communication errors into localized user-friendly error messages
    /// Provides appropriate messaging for different error types, HTTP status codes, and failure scenarios
    /// Implements special handling for common cases like 404 (API endpoint not ready)
    /// - Parameter error: The raw Error object from failed API communication
    /// - Returns: Localized string suitable for direct display in user interface
    /// Follows error localization best practices for internationalization support
    private func handleAPIError(_ error: Error) -> String {
        // Check if error is our custom APIError type for specialized categorization
        if let apiError = error as? APIError {
            switch apiError {
            case .notAuthenticated:
                return "Please log in to view the academic calendar"
            case .networkError:
                return "Network connection error. Please check your internet connection and try again."
            case .serverError(let code):
                // Special handling for 404 errors indicating API endpoint isn't available yet
                // Provides helpful guidance about API availability and expected timelines
                if code == 404 {
                    return "Calendar data is not available yet. The API endpoint may still be under development."
                }
                return "Server error (code: \(code)). Please try again later or contact technical support."
            case .decodingError:
                return "Error processing calendar data format. Please contact support for assistance."
            case .unknown:
                return "An unexpected error occurred while loading calendar data. Please try again."
            }
        }
        // Fallback for non-APIError types with informative but generic error message
        return "Failed to load calendar data: \(error.localizedDescription)"
    }
    
    // MARK: - Data Filtering and Query Methods
    
    /// Filters calendar entries for a specific month and year combination
    /// Provides date-based filtering for month view calendar displays and navigation
    /// - Parameters:
    ///   - year: The calendar year to filter entries for (e.g., 2025)
    ///   - month: The calendar month to filter entries for (1-12, where 1=January, 12=December)
    /// - Returns: Array of CalendarEntry objects for the specified month/year combination
    /// Used by calendar grid components to display only relevant monthly entries
    func entriesForMonth(year: Int, month: Int) -> [CalendarEntry] {
        return calendarEntries.filter { entry in
            let components = Calendar.current.dateComponents([.year, .month], from: entry.date)
            return components.year == year && components.month == month
        }
    }
    
    /// Finds calendar entry for a specific calendar date
    /// Supports date selection, daily content retrieval, and calendar navigation features
    /// - Parameter date: The target calendar date to find corresponding entry for
    /// - Returns: Optional CalendarEntry for the specified date, nil if no entry exists
    /// Used for date tapping interactions and daily detail view population
    func entryForDate(_ date: Date) -> CalendarEntry? {
        return calendarEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    // MARK: - Helper Methods for Calendar UI Components
    
    /// Determines if a specific date has an associated calendar entry
    /// Used for visual indicators in calendar grid (dots under dates with content)
    /// - Parameter date: The date to check for calendar entry existence
    /// - Returns: Boolean indicating whether the date has scheduled instructional content
    func hasEntryForDate(_ date: Date) -> Bool {
        return entryForDate(date) != nil
    }
    
    /// Retrieves all calendar entries within a specified date range
    /// Supports week view displays, date range filtering, and academic period views
    /// - Parameters:
    ///   - startDate: Inclusive start date of the range
    ///   - endDate: Inclusive end date of the range
    /// - Returns: Array of CalendarEntry objects within the specified date range
    func entriesInDateRange(startDate: Date, endDate: Date) -> [CalendarEntry] {
        return calendarEntries.filter { entry in
            entry.date >= startDate && entry.date <= endDate
        }
    }
    
    // MARK: - Data Statistics and Analytics Methods
    
    /// Calculates total number of instructional days in the loaded academic calendar
    /// Excludes holidays and non-instructional days from the count
    /// - Returns: Integer count of days with scheduled instructional content
    var totalInstructionalDays: Int {
        calendarEntries.filter { !$0.lessonName.isEmpty && $0.lessonName != "No Lesson" }.count
    }
    
    /// Calculates total number of assignments across all calendar entries
    /// Includes both assignments due and new assignments for comprehensive counting
    /// - Returns: Integer count of all assignments in the academic term
    var totalAssignments: Int {
        calendarEntries.reduce(0) { total, entry in
            total + entry.assignmentsDue.count + entry.newAssignments.count
        }
    }
}
