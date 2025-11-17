//
//  LessonPlanCardsView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/12/25.
//

import SwiftUI

// MARK: - Lesson Plan Cards View
/// Reusable component that displays all lesson plan cards for a given calendar entry
/// Used by both TodayView and CalendarCardStack to avoid duplication
/// Shows comprehensive lesson details in a stacked card interface
struct LessonPlanCardsView: View {
    // MARK: - Properties
    let entry: CalendarEntry              // The calendar entry containing lesson data
    let showSubmitFeedback: Bool          // Controls whether to show feedback button
    let onSubmitFeedback: (() -> Void)?   // Callback when feedback button is tapped
    
    @State private var showingLessonOutline = false  // Controls lesson outline sheet display
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Word of the Day Card
            /// Always the top card in the stack
            CardView(
                emoji: "📚",
                title: "Word of the Day",
                content: entry.wordOfTheDay,
                isTopCard: true
            )
            
            // MARK: - Lesson ID Card (Tappable)
            /// Opens lesson outline when tapped
            Button(action: {
                showingLessonOutline = true
            }) {
                CardView(
                    emoji: "🆔",
                    title: "Lesson ID",
                    content: entry.lessonID,
                    isTopCard: false
                )
            }
            .buttonStyle(PlainButtonStyle())  // Removes default button styling
            
            // MARK: - Lesson Name Card (Tappable)
            /// Also opens lesson outline when tapped
            Button(action: {
                showingLessonOutline = true
            }) {
                CardView(
                    emoji: "📘",
                    title: "Lesson Name",
                    content: entry.lessonName,
                    isTopCard: false
                )
            }
            .buttonStyle(PlainButtonStyle())  // Removes default button styling
            
            // MARK: - Main Objective Card
            CardView(
                emoji: "🎯",
                title: "Main Objective",
                content: entry.mainObjective,
                isTopCard: false
            )
            
            // MARK: - Instructor Card
            CardView(
                emoji: "👨‍🏫",
                title: "Instructor",
                content: entry.instructor,
                isTopCard: false
            )
            
            // MARK: - Daily Code Challenge Card
            CardView(
                emoji: "💻",
                title: "Daily Code Challenge",
                content: entry.codeChallenge,
                isTopCard: false
            )
            
            // MARK: - Assignments Due Card
            /// Dynamic content - shows assignment titles or "None"
            CardView(
                emoji: "🔬",
                title: "Assignments Due",
                content: entry.hasAssignmentsDue
                    ? entry.assignmentsDue.map { $0.title }.joined(separator: ", ")  // Join multiple assignments
                    : "None",  // Fallback when no assignments
                isTopCard: false
            )
            
            // MARK: - New Assignments Card
            /// Dynamic content - shows new assignment titles or "None"
            CardView(
                emoji: "📝",
                title: "New Assignments",
                content: entry.hasNewAssignments
                    ? entry.newAssignments.map { $0.title }.joined(separator: ", ")  // Join multiple new assignments
                    : "None",  // Fallback when no new assignments
                isTopCard: false
            )
            
            // MARK: - Reading Due Card
            CardView(
                emoji: "📖",
                title: "Reading Due",
                content: entry.readingDue,
                isTopCard: false
            )
            
            // MARK: - Submit Feedback Button (Optional)
            /// Only shown when showSubmitFeedback is true and callback is provided
            if showSubmitFeedback, let onSubmitFeedback = onSubmitFeedback {
                Button(action: onSubmitFeedback) {
                    HStack {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Submit Feedback")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 332, height: 56)           // Fixed size matching cards
                    .background(MountainlandColors.burgundy1) // Brand burgundy color
                    .cornerRadius(12)                        // Rounded corners
                    .shadow(
                        color: .black.opacity(0.15),         // Subtle shadow
                        radius: 4,
                        x: 0,
                        y: 2
                    )
                }
                .padding(.top, 48)  // Extra spacing above feedback button
            }
        }
        // MARK: - Lesson Outline Sheet
        /// Modal presentation for detailed lesson outline
        .sheet(isPresented: $showingLessonOutline) {
            LessonOutlineView(lessonOutline: entry.lessonOutline)
        }
    }
}
