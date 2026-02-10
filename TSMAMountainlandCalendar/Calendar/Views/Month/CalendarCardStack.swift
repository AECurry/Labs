//
//  CalendarCardStack.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

// *Calendar Card Stack
/// Displays lesson plan information for the currently selected calendar date
/// Used within Calendar views to show daily instructional content
/// Dynamically switches between loading, error, lesson, weekend, and empty states
struct CalendarCardStack: View {
    
    // *Dependencies
    
    let viewModel: CalendarViewModel   // Source of truth for selected date and lesson data
    
    // MARK: - Computed Properties
    
    /// Determines if the selected date falls on a weekend (Saturday or Sunday)
    private var isWeekend: Bool {
        let weekday = Calendar.current.component(.weekday, from: viewModel.selectedDate)
        return weekday == 1 || weekday == 7  // 1 = Sunday, 7 = Saturday
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // *Header
            // Displays contextual title based on selected date
            Text("Lesson Plan For \(headerDateText)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(MountainlandColors.smokeyBlack)
                .padding(.horizontal, 4)
            
            // *Content States
            if viewModel.isLoading {
                // Loading state while calendar data is being fetched
                loadingView
                
            } else if let error = viewModel.errorMessage {
                // Error state if calendar data fails to load
                CardView(
                    emoji: "⚠️",
                    title: "Error",
                    content: error,
                    cardStyle: .standalone  // ✅ Rounded corners
                )
                
            } else if isWeekend {
                // ✅ Weekend state - standalone card with rounded top
                CardView(
                    emoji: "🌴",
                    title: "Weekend",
                    content: "No class today. Enjoy your weekend!",
                    cardStyle: .standalone  // ✅ Rounded top for Calendar context
                )
                
            } else if let entry = viewModel.selectedDateEntry {
                // Lesson state – display full lesson plan cards
                LessonPlanCardsView(
                    entry: entry,
                    showSubmitFeedback: false,
                    onSubmitFeedback: nil,
                    hasHeaderAbove: false  // ✅ Calendar tab has no header above
                )
                
            } else {
                // Empty state – no lesson scheduled
                CardView(
                    emoji: "📅",
                    title: "No Lesson",
                    content: "No lesson scheduled for \(formattedSelectedDate)",
                    cardStyle: .standalone  // ✅ Rounded top
                )
            }
        }
    }
    
    // *Loading View
    
    private var loadingView: some View {
        // Centered loading indicator for calendar content
        HStack {
            Spacer()
            VStack(spacing: 12) {
                ProgressView()
                Text("Loading...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 40)
            Spacer()
        }
    }
    
    // *Date Formatting Helpers
    
    private var formattedSelectedDate: String {
        // Formats selected date for display in headers and messages
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: viewModel.selectedDate)
    }
    
    private var headerDateText: String {
        // Displays "Today" when applicable, otherwise formatted date
        Calendar.current.isDateInToday(viewModel.selectedDate)
            ? "Today"
            : formattedSelectedDate
    }
}

// MARK: - Preview
#Preview {
    CalendarCardStack(viewModel: CalendarViewModel())
        .padding()
        .background(MountainlandColors.platinum)
}
