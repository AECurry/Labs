//
//  CalendarDay.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/9/25.
//

import SwiftUI

// MARK: - Calendar Day Model
/// This file defines what each little square on the calendar should look like and know about itself.
/// It tracks whether a day is in the current month (or should be faded out), if it's today (so we can highlight it), if it's a holiday, and most importantly - if it has any assignments or events that students need to know about.
/// Used to control day cell appearance and interaction in month/week views
struct CalendarDay: Identifiable {
    // MARK: - Core Properties
    let id = UUID()                    // Unique identifier for SwiftUI rendering
    let date: Date                     // The actual date this cell represents
    let isCurrentMonth: Bool           // True if day belongs to the displayed month
    let isToday: Bool                  // True if this day is the current date
    let isHoliday: Bool                // True for holidays and non-school days
    let number: String                 // Day number for display (e.g., "13", "25")
    let hasCalendarEntry: Bool         // True if day has assignments, lessons, or events
    
    // MARK: - Visual State Notes
    /// This model drives calendar cell appearance:
    /// - isCurrentMonth: Fades out days from previous/next months
    /// - isToday: Highlights the current date with special styling
    /// - isHoliday: May show different color for non-instructional days
    /// - hasCalendarEntry: Shows indicator dot for days with content
}
