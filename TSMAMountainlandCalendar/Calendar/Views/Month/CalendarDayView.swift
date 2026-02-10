//
//  CalendarDayView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/9/25.
//

import SwiftUI

// *Calendar Day View
/// Represents a single day square in the monthly calendar grid
/// Displays the day number with visual indicators for holidays and today
/// Tapping a day triggers the `onSelect` closure
/// Reused multiple times (35–42) to build the full month view
struct CalendarDayView: View {
    
    // *Properties / Dependencies
    
    let day: CalendarDay      // Model containing day info (number, date, holiday, today)
    let userRole: UserRole    // Role info (used for potential role-based styling)
    let isSelected: Bool      // Tracks whether this day is selected (currently only for logic)
    let onSelect: () -> Void  // Action triggered when user taps this day
    
    var body: some View {
        // *Day Button
        Button(action: {
            // Debug log and trigger selection
            print("📅 Calendar day tapped: \(day.number) - \(day.date)")
            onSelect()
        }) {
            VStack(spacing: 0) {
                
                // *Day Number / Holiday Highlight
                ZStack {
                    if day.isHoliday {
                        // Holiday circle background
                        Circle()
                            .fill(MountainlandColors.burgundy1)
                            .frame(width: 36, height: 36)
                    }
                    
                    // Day number text
                    Text(day.number)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(
                            day.isHoliday ? .white :
                            (day.isCurrentMonth ? MountainlandColors.smokeyBlack : .gray.opacity(0.5))
                        )
                }
                .frame(height: 36)
                
                // *Today Indicator
                if day.isToday {
                    Circle()
                        .fill(MountainlandColors.burgundy1)
                        .frame(width: 8, height: 8)
                        .padding(.top, -4)
                } else {
                    Spacer()
                        .frame(height: 8)
                }
            }
            .frame(height: 46)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain) // Prevents default button styling
    }
}
