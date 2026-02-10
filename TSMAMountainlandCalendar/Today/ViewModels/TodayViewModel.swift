//
//  TodayViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation
import Observation

// MARK: - Today ViewModel
/// ViewModel for the Today tab
/// Manages daily lesson content, loading state, and error handling
@Observable
class TodayViewModel {
    
    // MARK: - State Properties
    
    /// Loaded lesson content for the selected day
    var dailyContent: CalendarEntry?
    
    /// Currently selected date
    /// Clears content when date changes
    var date: Date {
        didSet {
            if !Calendar.current.isDate(oldValue, inSameDayAs: date) {
                dailyContent = nil
            }
        }
    }
    
    /// Tracks API loading state
    var isLoading = false
    
    /// User-facing error message
    var errorMessage: String?

    // MARK: - Initialization
    
    /// Initializes the ViewModel with an optional starting date
    init(date: Date = Date()) {
        self.date = date
    }

    // MARK: - Data Loading
    
    /// Loads lesson content for the current date
    func loadDailyContent() async {
        // Ensure user is authenticated
        guard APIController.shared.isAuthenticated else {
            await MainActor.run {
                errorMessage = "Please log in to view today's lesson"
            }
            return
        }
        
        // Start loading state
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Always reset loading state
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            // Fetch lesson data from API
            let response = try await APIController.shared.fetchTodayContent()
            
            // Convert API response to app model
            let calendarEntry = CalendarEntry(from: response)
            
            // Update UI state
            await MainActor.run {
                dailyContent = calendarEntry
            }
            
        } catch {
            // Handle and display error
            await MainActor.run {
                errorMessage = handleAPIError(error)
            }
        }
    }
    
    // MARK: - Error Handling
    
    /// Converts API errors into user-friendly messages
    private func handleAPIError(_ error: Error) -> String {
        if let apiError = error as? APIError {
            switch apiError {
            case .notAuthenticated:
                return "Please log in to view today's lesson"
            case .networkError:
                return "Network error. Check your internet connection."
            case .serverError(let code):
                if code == 404 {
                    return "Today's lesson is not available yet."
                }
                return "Server error. Please try again later."
            case .decodingError:
                return "Error loading lesson data."
            case .unknown:
                return "An unknown error occurred."
            }
        }
        return "Failed to load content."
    }
    
    // MARK: - Helpers
    
    /// Loads lesson content for a specific date
    func loadDailyContent(for date: Date) async {
        self.date = date
        await loadDailyContent()
    }
    
    /// Indicates whether content is available
    var hasContent: Bool {
        dailyContent != nil
    }
    
    /// Formatted date string for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
