//
//  CalendarDetailView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Calendar Detail View
/// Detailed lesson plan view shown when a user taps a date in the calendar.
/// Displays all lesson components in individual card-style sections.
struct CalendarDetailView: View {

    // MARK: - Properties

    let selectedDate: Date          // Date selected from the calendar
    let userRole: UserRole          // User role (teacher/student) for permissions

    @State private var showingLessonOutline = false
    // NOTE: Assignment-related state intentionally left unused for now.
    // These can be safely removed later if assignment navigation is handled elsewhere.
    @State private var showingAssignmentOutline = false
    @State private var selectedAssignment: Assignment?

    @Environment(\.dismiss) private var dismiss

    /// Retrieves the calendar entry matching the selected date
    private var calendarEntry: CalendarEntry? {
        CalendarEntry.placeholders.first { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: selectedDate)
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // MARK: - Header Section
                    /// Displays the selected date and lesson ID (if available)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(formattedDate)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(MountainlandColors.smokeyBlack)

                        if let entry = calendarEntry,
                           let dayID = entry.dayID {
                            Text("Lesson \(dayID)")
                                .font(.subheadline)
                                .foregroundColor(MountainlandColors.battleshipGray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // MARK: - Content Cards
                    /// Displays lesson details using reusable CardView components
                    if let entry = calendarEntry {
                        VStack(spacing: 16) {

                            // Word of the Day
                            CardView(
                                emoji: "📚",
                                title: "Word of the Day",
                                content: entry.wordOfTheDay ?? "No word of the day",
                                isTopCard: true
                            )

                            // Lesson Name
                            CardView(
                                emoji: "📋",
                                title: "Lesson",
                                content: entry.displayName,
                                isTopCard: false
                            )

                            // Daily Code Challenge
                            CardView(
                                emoji: "💻",
                                title: "Code Challenge",
                                content: entry.dailyCodeChallengeName ?? "No code challenge today",
                                isTopCard: false
                            )

                            // Main Objective
                            CardView(
                                emoji: "🎯",
                                title: "Main Objective",
                                content: entry.mainObjective ?? "No main objective",
                                isTopCard: false
                            )

                            // MARK: - Assignments Section

                            // Assignments Due
                            if entry.hasAssignmentsDue {
                                CardView(
                                    emoji: "🔬",
                                    title: "Assignments Due",
                                    content: entry.assignmentsDue
                                        .map { $0.title }
                                        .joined(separator: ", "),
                                    isTopCard: false
                                )
                            } else {
                                CardView(
                                    emoji: "🔬",
                                    title: "Assignments Due",
                                    content: "None",
                                    isTopCard: false
                                )
                            }

                            // New Assignments
                            if entry.hasNewAssignments {
                                CardView(
                                    emoji: "🆕",
                                    title: "New Assignments",
                                    content: entry.newAssignments
                                        .map { $0.title }
                                        .joined(separator: ", "),
                                    isTopCard: false
                                )
                            } else {
                                CardView(
                                    emoji: "🆕",
                                    title: "New Assignments",
                                    content: "None",
                                    isTopCard: false
                                )
                            }

                            // Reading Due
                            CardView(
                                emoji: "📖",
                                title: "Reading Due",
                                content: entry.readingDue ?? "No reading due",
                                isTopCard: false
                            )
                        }
                        .padding(.horizontal)

                    } else {

                        // MARK: - No Lesson State
                        /// Shown when no lesson exists for the selected date
                        CardView(
                            emoji: "📅",
                            title: "No Lesson",
                            content: "No lesson scheduled for \(formattedSelectedDate)",
                            isTopCard: true
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(MountainlandColors.platinum)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(MountainlandColors.burgundy1)
                }
            }
        }
        // MARK: - Sheet Presentations

        /// Lesson Outline Sheet
        .sheet(isPresented: $showingLessonOutline) {
            if let entry = calendarEntry {
                LessonOutlineView(
                    lessonOutline: "Fetching lesson outline for \(entry.displayName)..."
                )
            }
        }
    }

    // MARK: - Helper Methods
    // NOTE: These MUST live outside `body`

    /// Formats date as "Tuesday, November 13, 2024"
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: selectedDate)
    }

    /// Formats date as "Nov 13"
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: selectedDate)
    }
}

// MARK: - Preview

#Preview {
    CalendarDetailView(
        selectedDate: Date(),
        userRole: .teacher
    )
}
