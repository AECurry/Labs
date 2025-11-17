//
//  CalendarDetailView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Calendar Detail View
/// This is the detailed lesson plan view that appears at the bottom of the calendar when you tap on a specific date in the calendar.
/// Displays all lesson components in individual cards

struct CalendarDetailView: View {
    // MARK: - Properties
    let selectedDate: Date          // The date user selected from calendar
    let userRole: UserRole          // User role (teacher/student) for permissions
    @State private var showingLessonOutline = false      // Controls lesson outline sheet
    @State private var showingAssignmentOutline = false  // Controls assignment sheet
    @State private var selectedAssignment: Assignment?   // Currently selected assignment
    @State private var completedAssignments: Set<UUID> = [] // Tracks completion status
    @Environment(\.dismiss) private var dismiss          // Environment dismiss action
    
    // Get the calendar entry for the selected date
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
                    /// Shows selected date and lesson ID if available
                    VStack(alignment: .leading, spacing: 8) {
                        Text(formattedDate)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(MountainlandColors.smokeyBlack)
                        
                        if let entry = calendarEntry {
                            Text("Lesson \(entry.lessonID)")
                                .font(.subheadline)
                                .foregroundColor(MountainlandColors.battleshipGray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: - Content Cards
                    /// Display lesson details in individual card components
                    if let entry = calendarEntry {
                        // Individual cards for each section (matches TodayView style)
                        VStack(spacing: 16) {
                            // Word of the Day card
                            CardView(emoji: "📚", title: "Word of the Day", content: entry.wordOfTheDay, isTopCard: true)
                            
                            // Instructor card
                            CardView(emoji: "👨‍🏫", title: "Instructor", content: entry.instructor, isTopCard: false)
                            
                            // Code Challenge card
                            CardView(emoji: "💻", title: "Code Challenge", content: entry.codeChallenge, isTopCard: false)
                            
                            // Lesson Topic/Outline card
                            CardView(emoji: "📋", title: "Topic / Outline", content: entry.lessonName, isTopCard: false)
                            
                            // MARK: - Assignments Section
                            /// Dynamic card showing assignments due or "None"
                            if entry.hasAssignmentsDue {
                                CardView(
                                    emoji: "🔬",
                                    title: "Labs / Projects Due",
                                    content: entry.assignmentsDue.map { $0.title }.joined(separator: ", "),
                                    isTopCard: false
                                )
                            } else {
                                CardView(emoji: "🔬", title: "Labs / Projects Due", content: "None", isTopCard: false)
                            }
                            
                            // Reading/Hybrid Work card
                            CardView(emoji: "📖", title: "Reading / Hybrid Work", content: entry.readingDue, isTopCard: false)
                            
                            // Review Topic card (using Main Objective)
                            CardView(emoji: "🔄", title: "Review Topic", content: entry.mainObjective, isTopCard: false)
                        }
                        .padding(.horizontal)
                        
                    } else {
                        // MARK: - No Lesson State
                        /// Displayed when no lesson is scheduled for selected date
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
            .background(MountainlandColors.platinum)  // Light gray background
            .navigationBarTitleDisplayMode(.inline)   // Compact navigation bar
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()  // Close the detail view
                    }
                    .foregroundColor(MountainlandColors.burgundy1)  // Brand color
                }
            }
        }
        // MARK: - Sheet Presentations
        /// Modal sheets for additional content and actions
        
        // Lesson Outline Sheet
        .sheet(isPresented: $showingLessonOutline) {
            if let entry = calendarEntry {
                LessonOutlineView(lessonOutline: entry.lessonOutline)
            }
        }
        
        // Assignment Outline Sheet
        .sheet(isPresented: $showingAssignmentOutline) {
            if let assignment = selectedAssignment {
                AssignmentOutlineView(
                    assignment: assignment,
                    isCompleted: completedAssignments.contains(assignment.id),
                    onToggleComplete: {
                        // Toggle completion status
                        if completedAssignments.contains(assignment.id) {
                            completedAssignments.remove(assignment.id)
                        } else {
                            completedAssignments.insert(assignment.id)
                        }
                    }
                )
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Formats date as "Tuesday, November 13, 2024"
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: selectedDate)
    }
    
    /// Formats date as "Nov 13" for compact display
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: selectedDate)
    }
}

#Preview {
    CalendarDetailView(selectedDate: Date(), userRole: .teacher)
}
