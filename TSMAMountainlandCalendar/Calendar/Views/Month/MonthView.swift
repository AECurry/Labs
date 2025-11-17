//
//  MonthView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Month View
/// Main container view that displays a complete monthly calendar
/// Includes month header, weekday labels, and the calendar grid with styling
/// Essentially the "frame" around the calendar - it takes the raw calendar grid and presents it in that beautiful, polished card interface with proper headers and styling!
struct MonthView: View {
    // MARK: - Properties
    @Binding var selectedDate: Date  // Currently selected date (two-way binding)
    
    // Define columns once and share them
    /// 7-column grid layout for calendar days (Sunday through Saturday)
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    // MARK: - Computed Properties
    /// Formats the current month and year for display (e.g., "November 2024")
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Month Header
            /// Displays month/year and calendar icon
            HStack(spacing: 8) {
                Text(monthYearText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(MountainlandColors.smokeyBlack)
                
                Spacer()  // Pushes content to edges
                
                // Calendar icon for visual branding
                Image(systemName: "calendar")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(MountainlandColors.burgundy1)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            .padding(.horizontal, 16)
            
            // MARK: - Calendar Container
            /// White card containing the calendar grid with shadow and rounded corners
            VStack(spacing: 0) {
                // Weekday headers (S M T W T F S)
                WeekdayHeaderView(columns: columns)
                    .padding(.horizontal, 0)  // No horizontal padding
                
                // Main calendar grid with days
                CalendarGridView(
                    currentDate: selectedDate,
                    selectedDate: $selectedDate,  // Pass the binding down
                    columns: columns
                )
                .padding(.horizontal, 0)  // No horizontal padding
            }
            .padding(16)  // Internal padding within the white card
            .background(Color.white)  // White card background
            .cornerRadius(12)  // Rounded corners for the card
            .shadow(
                color: .black.opacity(0.1),  // Subtle shadow
                radius: 3,
                x: 0,
                y: 2
            )
            .padding(.horizontal, 16)  // External padding from screen edges
        }
    }
}

#Preview {
    MonthView(selectedDate: .constant(Date()))
}
