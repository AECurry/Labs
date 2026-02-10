//
//  CalendarViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation
import Observation

// *Calendar ViewModel
/// Central data manager for the academic calendar feature
/// Acts as the bridge between CalendarView UI and APIController
/// Handles loading, selection, and filtering of calendar entries
/// Observable so SwiftUI views automatically update when data changes
@Observable
class CalendarViewModel {
    
    // *State Properties
    
    var calendarEntries: [CalendarEntry] = []   // All calendar entries loaded from the API
    var isLoading = false                       // Tracks loading state for UI spinners
    var errorMessage: String?                   // Stores user-facing error messages
    
    var selectedDate: Date = Date()             // Currently selected date in the calendar
    var selectedDateEntry: CalendarEntry?       // Entry that matches the selected date
    
    // *Data Loading
    
    func loadCalendarData() async {
        // Ensure user is authenticated before fetching calendar data
        guard APIController.shared.isAuthenticated else {
            await MainActor.run {
                errorMessage = "Please log in to view the calendar"
            }
            return
        }
        
        // Begin loading state
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Always stop loading when function exits
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            // Fetch raw calendar entry DTOs from API
            let response = try await APIController.shared.fetchAllCalendarEntries()
            
            // Convert DTOs into internal CalendarEntry models
            let entries = response.map { CalendarEntry(from: $0) }
            
            await MainActor.run {
                calendarEntries = entries          // Store loaded entries
                selectedDate = Date()              // Default to today
                updateSelectedDateEntry()          // Sync selected entry
            }
            
        } catch {
            // Handle API or decoding errors
            await MainActor.run {
                errorMessage = "Failed to load calendar: \(error.localizedDescription)"
            }
        }
    }
    
    // *Date Selection
    
    func selectDate(_ date: Date) async {
        // Update selected date and corresponding calendar entry
        await MainActor.run {
            selectedDate = date
            updateSelectedDateEntry()
        }
    }
    
    private func updateSelectedDateEntry() {
        // Find the calendar entry that matches the selected date
        selectedDateEntry = entryForDate(selectedDate)
    }
    
    // *Calendar Queries
    
    func entriesForMonth(year: Int, month: Int) -> [CalendarEntry] {
        // Filter entries to only those in the specified month and year
        calendarEntries.filter { entry in
            let components = Calendar.current.dateComponents([.year, .month], from: entry.date)
            return components.year == year && components.month == month
        }
    }
    
    func entryForDate(_ date: Date) -> CalendarEntry? {
        // Find a calendar entry that falls on the same day
        calendarEntries.first {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    func hasEntryForDate(_ date: Date) -> Bool {
        // Used by calendar UI to highlight days with content
        entryForDate(date) != nil
    }
    
    // *Formatting Helpers
    
    private func formattedDate(_ date: Date) -> String {
        // Converts a date into a readable string format
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
