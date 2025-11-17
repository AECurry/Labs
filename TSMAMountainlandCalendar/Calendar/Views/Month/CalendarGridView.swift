//
//  CalendarGridView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/9/25.
//

import SwiftUI

// MARK: - Calendar Grid View
/// This is the brain of the Calendar
/// Main calendar grid that displays a full month view with days from previous/next months
/// Handles day selection and generates the complete 6-week calendar layout
struct CalendarGridView: View {
    // MARK: - Properties
    let currentDate: Date           // The month being displayed (e.g., November 2024)
    @Binding var selectedDate: Date // Currently selected date (two-way binding)
    let columns: [GridItem]         // Grid layout configuration for day columns
    
    private let calendar = Calendar.current // Calendar instance for date calculations
    
    // MARK: - Computed Properties
    /// Generates the complete month data including previous/next month days
    private var monthData: [CalendarDay] {
        generateMonthData(for: currentDate)
    }
    
    // MARK: - Body
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            // MARK: - Day Grid Generation
            /// Creates a grid of 42 day views (6 weeks × 7 days)
            ForEach(monthData) { day in
                CalendarDayView(
                    day: day,
                    userRole: .teacher,
                    isSelected: calendar.isDate(day.date, inSameDayAs: selectedDate)
                ) {
                    // Update the selected date when a day is tapped
                    selectedDate = day.date
                }
            }
        }
        .padding(.vertical, 8) // Vertical spacing around the grid
    }
    
    // MARK: - Month Data Generation
    /// Generates complete calendar data for a month including padding days
    /// Returns exactly 42 days (6 weeks) to maintain consistent calendar layout
    private func generateMonthData(for date: Date) -> [CalendarDay] {
        var days: [CalendarDay] = []
        
        // Get the first day of the month
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstOfMonth = calendar.date(from: components)!
        
        // Get the weekday of the first day (0 = Sunday, 6 = Saturday)
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1
        
        // Get the number of days in the month
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numberOfDays = range.count
        
        // MARK: - Previous Month Days
        /// Add days from the end of previous month to fill the first week
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: date)!
        let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth)!
        let previousMonthDays = previousMonthRange.count
        
        for i in (previousMonthDays - firstWeekday)..<previousMonthDays {
            let dayDate = calendar.date(byAdding: .day, value: i - previousMonthDays + 1, to: firstOfMonth)!
            let hasEntry = CalendarEntry.placeholders.contains {
                calendar.isDate($0.date, inSameDayAs: dayDate)
            }
            let isHoliday = isHolidayOrVacation(dayDate)
            
            days.append(CalendarDay(
                date: dayDate,
                isCurrentMonth: false,      // Grayed out - not in current month
                isToday: calendar.isDate(dayDate, inSameDayAs: Date()),
                isHoliday: isHoliday,
                number: "\(i + 1)",         // Day number (1-31)
                hasCalendarEntry: hasEntry  // Whether this day has lesson data
            ))
        }
        
        // MARK: - Current Month Days
        /// Add all days of the current month
        for day in 1...numberOfDays {
            let dayDate = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)!
            let hasEntry = CalendarEntry.placeholders.contains {
                calendar.isDate($0.date, inSameDayAs: dayDate)
            }
            let isToday = calendar.isDate(dayDate, inSameDayAs: Date())
            let isHoliday = isHolidayOrVacation(dayDate)
            
            days.append(CalendarDay(
                date: dayDate,
                isCurrentMonth: true,       // Normal display - in current month
                isToday: isToday,           // Show today indicator dot
                isHoliday: isHoliday,       // Holiday styling
                number: "\(day)",           // Day number (1-31)
                hasCalendarEntry: hasEntry  // Whether this day has lesson data
            ))
        }
        
        // MARK: - Next Month Days
        /// Add days from the beginning of next month to complete 6 weeks (42 days)
        let totalDaysNeeded = 42
        let remainingDays = totalDaysNeeded - days.count
        
        for day in 1...remainingDays {
            let dayDate = calendar.date(byAdding: .day, value: numberOfDays + day - 1, to: firstOfMonth)!
            let hasEntry = CalendarEntry.placeholders.contains {
                calendar.isDate($0.date, inSameDayAs: dayDate)
            }
            let isHoliday = isHolidayOrVacation(dayDate)
            
            days.append(CalendarDay(
                date: dayDate,
                isCurrentMonth: false,      // Grayed out - not in current month
                isToday: false,
                isHoliday: isHoliday,
                number: "\(day)",           // Day number (1-31)
                hasCalendarEntry: hasEntry  // Whether this day has lesson data
            ))
        }
        
        return days
    }
    
    // MARK: - Holiday Detection
    /// Determines if a given date is a holiday or vacation day
    /// Uses hardcoded holiday list - would typically come from a database or API
    private func isHolidayOrVacation(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: date)
        
        // Example holidays (replace with real data later)
        let holidays = [
            (11, 26), // Day before Thanksgiving
            (11, 27), // Thanksgiving
            (11, 28), // Day after Thanksgiving
            (12, 25), // Christmas
            // Add more holidays/vacations as needed
        ]
        
        return holidays.contains { $0.0 == components.month && $0.1 == components.day }
    }
}
