//
//  MonthView.swift (UPDATED VERSION)
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Month View
/// Main container view that displays a complete monthly calendar
/// Includes weekday labels and the calendar grid with styling
/// Header has been moved to CalendarView for better tap gesture handling
struct MonthView: View {
    // MARK: - Properties
    @Binding var selectedDate: Date  // Currently selected date (two-way binding)
    
    // Define columns once and share them
    /// 7-column grid layout for calendar days (Sunday through Saturday)
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
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
