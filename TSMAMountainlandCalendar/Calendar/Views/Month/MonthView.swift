//
//  MonthView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// *Month View
/// Displays a full monthly calendar grid with weekday labels
/// Handles layout and styling for the month container
/// Header is moved to CalendarView to simplify tap gestures
struct MonthView: View {
    
    // *Binding Properties
    @Binding var selectedDate: Date   // Tracks currently selected date in the month view
    
    // *Layout Properties
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7) // 7 columns for days of the week
    
    var body: some View {
        VStack(spacing: 0) {
            
            // *Month Container
            VStack(spacing: 0) {
                
                // *Weekday Labels
                /// Displays "Sun, Mon, Tue..." across the top of the month grid
                WeekdayHeaderView(columns: columns)
                    .padding(.horizontal, 0)
                
                // *Calendar Grid
                /// Displays each day of the month in a 7-column grid
                CalendarGridView(
                    currentDate: selectedDate,
                    selectedDate: $selectedDate,
                    columns: columns
                )
                .padding(.horizontal, 0)
            }
            .padding(16)
            .background(Color.white)  // White card background for month
            .cornerRadius(12)         // Rounded corners for card effect
            .shadow(
                color: .black.opacity(0.1),
                radius: 3,
                x: 0,
                y: 2
            )
            .padding(.horizontal, 16) // Outer horizontal spacing for the month container
        }
    }
}

// *Preview
/// Provides Xcode live preview with a constant date binding
#Preview {
    MonthView(selectedDate: .constant(Date()))
}
