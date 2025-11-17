//
//  WeekdayHeaderView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/9/25.
//

import SwiftUI

// MARK: - Weekday Header View
/// Displays the weekday labels (Sun, Mon, Tue, etc.) above the calendar grid
/// Provides consistent column alignment with the calendar days below
struct WeekdayHeaderView: View {
    // MARK: - Properties
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]  // Abbreviated weekday names
    let columns: [GridItem]  // Grid layout matching the calendar grid columns
    
    // MARK: - Body
    var body: some View {
        // MARK: - Weekday Grid
        /// 7-column grid matching the calendar day grid for perfect alignment
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(weekdays, id: \.self) { day in
                Text(day)
                    .font(.system(size: 14, weight: .semibold))  // Readable, bold text
                    .foregroundColor(MountainlandColors.smokeyBlack)  // Brand text color
                    .frame(maxWidth: .infinity)  // Expands to fill column width evenly
            }
        }
        .padding(.vertical, 8)  // Vertical spacing above and below weekday labels
        // REMOVED: .padding(.horizontal, 16) - Now handled by parent container
    }
}
