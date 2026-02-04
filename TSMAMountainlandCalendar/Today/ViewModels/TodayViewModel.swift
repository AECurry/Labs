//
//  TodayViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation
import Observation

// MARK: - Today ViewModel
/// Primary ViewModel responsible for managing daily lesson content and calendar data for the Today tab
/// Serves as the intermediary between the TodayView UI and the APIController data layer
/// Handles API communication, data transformation, error management, and state synchronization
/// Implements the @Observable protocol for reactive UI updates with SwiftUI
/// Follows MVVM architecture principles with clean separation of concerns
@Observable
class TodayViewModel {
    // MARK: - State Properties
    
    /// The currently loaded calendar entry containing today's comprehensive lesson data
    /// Includes instructional content, assignments, daily challenges, and vocabulary components
    /// Nil when no content has been loaded, during loading operations, or when API fails
    /// Automatically triggers UI updates when modified due to @Observable compliance
    var dailyContent: CalendarEntry?
    
    /// The date currently being displayed and managed by the ViewModel
    /// Automatically clears dailyContent when changed to trigger fresh API loading
    /// Ensures data integrity by preventing stale content display after date navigation
    var date: Date {
        didSet {
            // Clear content when date changes to trigger fresh API loading
            // Prevents displaying incorrect or outdated content for the wrong date
            // Uses Calendar comparison to handle timezone and time component differences
            if !Calendar.current.isDate(oldValue, inSameDayAs: date) {
                dailyContent = nil
            }
        }
    }
    
    /// Loading state indicator tracking asynchronous API operations
    /// Controls UI display of progress indicators, loading spinners, and skeleton screens
    /// Set to true during API calls and automatically reset to false upon completion
    /// Enables responsive UI feedback during data retrieval operations
    var isLoading = false
    
    /// User-friendly error message for display when API operations fail
    /// Provides actionable feedback for network issues, authentication problems, or server errors
    /// Automatically cleared when new loading operations begin to prevent stale error display
    /// Uses localized error descriptions for internationalization support
    var errorMessage: String?

    // MARK: - Initialization
    
    /// Creates a new TodayViewModel instance with optional initial date parameter
    /// Sets up initial state for Today view content management and API integration
    /// - Parameter date: The initial date to load content for (defaults to current system date)
    /// Uses dependency injection for testability and flexibility in date management
    init(date: Date = Date()) {
        self.date = date
    }

    // MARK: - Primary Data Loading Method
    
    /// Asynchronously loads daily lesson content from the API for the current date
    /// Manages the complete lifecycle of API communication including authentication,
    /// loading states, error handling, data transformation, and UI synchronization
    /// Should be called when TodayView appears or when date selection changes
    /// Implements proper Swift Concurrency with MainActor coordination for thread safety
    /// Follows industry best practices for network request management in SwiftUI apps
    func loadDailyContent() async {
        // Verify user authentication before attempting API request
        // Prevents unauthorized API calls and provides appropriate user feedback
        // Checks APIController's authentication state to ensure valid user session
        guard APIController.shared.isAuthenticated else {
            await MainActor.run {
                errorMessage = "Please log in to view today's lesson"
            }
            return
        }
        
        // Set loading state to true to trigger UI loading indicators
        // Must update @Observable properties on MainActor for thread safety
        // Ensures UI reflects loading state immediately when method is called
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Ensure loading state is reset regardless of success or failure
        // Uses defer block for guaranteed cleanup to prevent perpetual loading states
        // Implements Task with @MainActor attribute for proper concurrency handling
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            // Fetch today's calendar content from the API server
            // Uses APIController's fetchTodayContent method for standardized API communication
            // Network call executes on background thread automatically via Swift Concurrency
            // Implements timeout and retry logic through URLSession configuration
            let response = try await APIController.shared.fetchTodayContent()
            
            // Convert API DTO response to internal CalendarEntry model
            // Uses CalendarEntry's initializer for consistent data transformation
            // Handles optional values and type conversions with appropriate defaults
            let calendarEntry = CalendarEntry(from: response)
            
            // Update UI with loaded content on MainActor for thread safety
            // @Observable properties must be updated on main thread for proper UI updates
            // Triggers SwiftUI view updates automatically through property observation
            await MainActor.run {
                dailyContent = calendarEntry
            }
            
        } catch let apiError {
            // Handle and store error for UI display on MainActor
            // Converts technical API errors to user-friendly localized messages
            // Provides meaningful error categorization for troubleshooting and user guidance
            await MainActor.run {
                errorMessage = handleAPIError(apiError)
            }
        }
    }
    
    // MARK: - Error Handling Utility Method
    
    /// Transforms raw API errors into user-friendly localized error messages
    /// Provides appropriate messaging for different error types and HTTP status codes
    /// Implements special handling for common scenarios like 404 (API not ready)
    /// - Parameter error: The raw Error object from API call failure
    /// - Returns: Localized string suitable for display in user interface
    /// Follows error localization best practices for internationalization support
    private func handleAPIError(_ error: Error) -> String {
        // Check if error is our custom APIError type for specialized handling
        if let apiError = error as? APIError {
            switch apiError {
            case .notAuthenticated:
                return "Please log in to view today's lesson"
            case .networkError:
                return "Network error. Please check your internet connection"
            case .serverError(let code):
                // Special handling for 404 errors when API endpoint isn't ready yet
                // Provides helpful guidance about API availability status
                if code == 404 {
                    return "Today's lesson data is not available yet. Please check back later."
                }
                return "Server error (code: \(code)). Please try again later."
            case .decodingError:
                return "Error processing lesson data. Please contact support."
            case .unknown:
                return "An unknown error occurred. Please try again."
            }
        }
        // Fallback for non-APIError types with generic but informative message
        return "Failed to load daily content: \(error.localizedDescription)"
    }
    
    // MARK: - Public Interface Methods
    
    /// Convenience method for loading daily content for a specific date
    /// Updates internal date state and triggers asynchronous data loading
    /// - Parameter date: The target date to load calendar content for
    /// Used for calendar navigation and date-specific content loading scenarios
    func loadDailyContent(for date: Date) async {
        self.date = date
        await loadDailyContent()
    }
    
    /// Boolean computed property indicating whether the ViewModel has successfully loaded content
    /// Used for conditional UI rendering, empty state detection, and content availability checks
    /// Returns true when dailyContent contains valid, non-nil data
    var hasContent: Bool {
        dailyContent != nil
    }
    
    /// Formatted date string for display in the UI using long date style
    /// Provides localized date formatting appropriate for user's locale and region
    /// Example outputs: "November 13, 2025" (en-US), "13 novembre 2025" (fr-FR)
    /// Maintains consistent date presentation across the application
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
