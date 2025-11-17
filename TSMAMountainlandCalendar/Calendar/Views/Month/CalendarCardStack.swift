//
//  CalendarCardStack.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

// MARK: - Calendar Card Stack
/// Displays lesson plan information for a selected calendar date
/// Shows either detailed lesson cards or a "no lesson" message
/// Used in calendar views to show daily instructional content
struct CalendarCardStack: View {
    // MARK: - Properties
    let todayViewModel: TodayViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Section Header
            /// Title indicating this section shows daily lesson plans
            Text("Lesson Plan For \(headerDateText)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(MountainlandColors.smokeyBlack)
                .padding(.horizontal, 4)  // Small side padding for visual alignment
            
            // MARK: - Loading State
            /// Shows progress indicator while fetching lesson data
            if todayViewModel.isLoading {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading lesson...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 40)
                    Spacer()
                }
            }
            // MARK: - Error State
            /// Shows error message if lesson data fails to load
            else if let error = todayViewModel.error {
                CardView(
                    emoji: "⚠️",
                    title: "Error Loading Lesson",
                    content: error,
                    isTopCard: true
                )
            }
            // MARK: - Conditional Content
            /// Shows either lesson cards or "no lesson" message based on date
            else if let entry = todayViewModel.dailyContent {
                // MARK: - Lesson Plan Cards
                /// Displays detailed lesson information when a lesson exists
                LessonPlanCardsView(
                    entry: entry,
                    showSubmitFeedback: false,      // Feedback disabled in calendar view
                    onSubmitFeedback: nil           // No feedback action in this context
                )
            } else {
                // MARK: - No Lesson Card
                /// Friendly message shown when no lesson is scheduled for selected date
                CardView(
                    emoji: "📅",                    // Calendar emoji for visual interest
                    title: "No Lesson",             // Clear status message
                    content: "No lesson scheduled for \(formattedSelectedDate)", // Specific date reference
                    isTopCard: true                 // Single card appearance
                )
            }
        }
    }
    
    // MARK: - Date Formatting
    /// Formats the selected date for display in the "no lesson" message
    /// Uses abbreviated month and day format (e.g., "Nov 13")
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"  // Month abbreviation and day number
        return formatter.string(from: todayViewModel.date)
    }
    
    /// Determines header text based on whether selected date is today
    /// Shows "Today" for current date, otherwise shows the date
    private var headerDateText: String {
        if Calendar.current.isDateInToday(todayViewModel.date) {
            return "Today"
        } else {
            return formattedSelectedDate
        }
    }
}

#Preview {
    CalendarCardStack(todayViewModel: TodayViewModel())
}
