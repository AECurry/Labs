//
//  CalendarDayView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/9/25.
//

import SwiftUI

// MARK: - Calendar Day View
/// This file creates the individual day square the user sees in the monthly calendar grid.
/// Shows date number with holiday highlighting (full circile around the number) and today indicator(small circle underneath the number) both are in burgundy1.
/// When you tap a day, it triggers the onSelect action.
/// No visual change when selected (just the tap action).
/// This is the building block that gets repeated 35-42 times to create the monthly calendar view.

struct CalendarDayView: View {
    // MARK: - Properties
    let day: CalendarDay           // Data model containing day information
    let userRole: UserRole         // User role for potential permission-based styling
    let isSelected: Bool           // Whether this day is currently selected
    let onSelect: () -> Void       // Callback when day is tapped
    
    // MARK: - Body
    var body: some View {
        // Interactive day button
        Button(action: onSelect) {
            VStack(spacing: 0) {
                // MARK: - Date Number Display
                /// Shows the day number with holiday highlighting
                ZStack {
                    // Holiday circle background (keep this)
                    if day.isHoliday {
                        Circle()
                            .fill(MountainlandColors.burgundy1)  // Brand color for holidays
                            .frame(width: 36, height: 36)       // Circular highlight behind number
                    }
                    
                    // Date number - No visual change for selection
                    Text(day.number)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(
                            day.isHoliday ? .white :                    // White text on holiday background
                            (day.isCurrentMonth ? MountainlandColors.smokeyBlack : .gray.opacity(0.5))  // Black for current month, gray for other months
                        )
                }
                .frame(height: 36)  // Fixed height for date number area
                
                // MARK: - Today Indicator
                /// Shows dot below date for today, otherwise empty space
                if day.isToday {
                    Circle()
                        .fill(MountainlandColors.burgundy1)  // Same brand color as holidays
                        .frame(width: 8, height: 8)          // Small dot indicator
                        .padding(.top, -4)                   // Negative padding to pull dot closer to number
                } else {
                    // REMOVED: Selection dot
                    Spacer()
                        .frame(height: 8)  // Maintain consistent spacing even when no dot
                }
            }
            .frame(height: 46)          // Total fixed height for the day cell
            .frame(maxWidth: .infinity)  // Expands to fill available grid space
        }
        .buttonStyle(.plain)  // Removes default button styling for clean appearance
    }
}
