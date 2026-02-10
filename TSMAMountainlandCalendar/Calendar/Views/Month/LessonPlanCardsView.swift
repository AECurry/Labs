//
//  LessonPlanCardsView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/12/25.
//

import SwiftUI

// *Lesson Plan Cards View
/// Reusable component displaying all lesson plan cards for a calendar entry
/// Used in TodayView and CalendarCardStack to avoid code duplication
/// Shows comprehensive lesson details with context-aware card styling
/// Adapts first card corner style based on whether a header sits above it
struct LessonPlanCardsView: View {
    
    // *Properties
    let entry: CalendarEntry              // Calendar entry containing lesson data
    let showSubmitFeedback: Bool          // Controls visibility of feedback button
    let onSubmitFeedback: (() -> Void)?   // Callback triggered when feedback button is tapped
    let hasHeaderAbove: Bool              // ✅ NEW: Indicates if DateHeaderView sits above (Today tab)
    
    @State private var showingLessonOutline = false  // Controls lesson outline sheet presentation
    
    // MARK: - Computed Property
    /// Determines the card style for the first card based on context
    /// Today tab (hasHeaderAbove = true): Flat top to connect with DateHeaderView
    /// Calendar tab (hasHeaderAbove = false): Rounded top for standalone appearance
    private var firstCardStyle: CardView.CardStyle {
        hasHeaderAbove ? .topOfStack : .standalone
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // *Word of the Day Card
            /// First card - styling adapts based on whether header sits above
            CardView(
                emoji: "📚",
                title: "Word of the Day",
                content: entry.wordOfTheDay ?? "No word of the day",
                cardStyle: firstCardStyle  // ✅ Context-aware: flat in Today, rounded in Calendar
            )
            
            // *Day ID Card (Tappable)
            /// Opens lesson outline modal when tapped
            Button(action: { showingLessonOutline = true }) {
                CardView(
                    emoji: "🆔",
                    title: "Day ID",
                    content: entry.dayID ?? "No day ID",
                    cardStyle: .standalone  // Always rounded
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // *Lesson Name Card (Tappable)
            /// Opens lesson outline modal when tapped
            Button(action: { showingLessonOutline = true }) {
                CardView(
                    emoji: "📘",
                    title: "Lesson Name",
                    content: entry.displayName,
                    cardStyle: .standalone  // Always rounded
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // *Main Objective Card
            CardView(
                emoji: "🎯",
                title: "Main Objective",
                content: entry.mainObjective ?? "No main objective",
                cardStyle: .standalone  // Always rounded
            )
            
            // *Daily Code Challenge Card
            CardView(
                emoji: "💻",
                title: "Daily Code Challenge",
                content: entry.dailyCodeChallengeName ?? "No code challenge today",
                cardStyle: .standalone  // Always rounded
            )
            
            // *Assignments Due Card
            /// Lists assignments due today or "None" if empty
            CardView(
                emoji: "🔬",
                title: "Assignments Due",
                content: entry.hasAssignmentsDue
                    ? entry.assignmentsDue.map { $0.title }.joined(separator: ", ")
                    : "None",
                cardStyle: .standalone  // Always rounded
            )
            
            // *New Assignments Card
            /// Lists new assignments introduced today or "None" if empty
            CardView(
                emoji: "📝",
                title: "New Assignments",
                content: entry.hasNewAssignments
                    ? entry.newAssignments.map { $0.title }.joined(separator: ", ")
                    : "None",
                cardStyle: .standalone  // Always rounded
            )
            
            // *Reading Due Card
            CardView(
                emoji: "📖",
                title: "Reading Due",
                content: entry.readingDue ?? "No reading due",
                cardStyle: .standalone  // Always rounded
            )
            
            // *Holiday Card (Conditional)
            /// Shown only if entry is a holiday
            if entry.holiday {
                CardView(
                    emoji: "🎉",
                    title: "Holiday",
                    content: "Today is a holiday - no classes",
                    cardStyle: .standalone  // Always rounded
                )
            }
            
            // *Submit Feedback Button (Optional)
            /// Visible only if showSubmitFeedback is true and callback is provided
            if showSubmitFeedback, let onSubmitFeedback = onSubmitFeedback {
                Button(action: onSubmitFeedback) {
                    HStack {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Submit Feedback")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(width: 332, height: 56)
                    .background(MountainlandColors.burgundy1)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                }
                .padding(.top, 48)
            }
        }
        
        // *Lesson Outline Sheet
        /// Modal view showing detailed lesson outline
        .sheet(isPresented: $showingLessonOutline) {
            let outlineContent = createLessonOutlineContent()
            LessonOutlineView(lessonOutline: outlineContent)
        }
    }
    
    // *Helper Method
    /// Generates a markdown-style lesson outline string from calendar entry data
    private func createLessonOutlineContent() -> String {
        var outline = "# \(entry.displayName)\n\n"
        
        if let dayID = entry.dayID { outline += "**Day ID:** \(dayID)\n\n" }
        if let lessonID = entry.lessonID { outline += "**Lesson ID:** \(lessonID.uuidString)\n\n" }
        if let mainObjective = entry.mainObjective { outline += "## Main Objective\n\(mainObjective)\n\n" }
        if let readingDue = entry.readingDue { outline += "## Reading Due\n\(readingDue)\n\n" }
        
        if entry.hasAssignmentsDue {
            outline += "## Assignments Due\n"
            for assignment in entry.assignmentsDue {
                outline += "- \(assignment.title) (Due: \(assignment.formattedDueDate))\n"
            }
            outline += "\n"
        }
        
        if entry.hasNewAssignments {
            outline += "## New Assignments\n"
            for assignment in entry.newAssignments {
                outline += "- \(assignment.title) (Due: \(assignment.formattedDueDate))\n"
            }
            outline += "\n"
        }
        
        if let codeChallenge = entry.dailyCodeChallengeName {
            outline += "## Code Challenge\n\(codeChallenge)\n\n"
        }
        
        if let wordOfDay = entry.wordOfTheDay {
            outline += "## Word of the Day\n\(wordOfDay)\n\n"
        }
        
        if entry.holiday {
            outline += "## Note\nToday is a holiday. No classes scheduled.\n"
        }
        
        return outline
    }
}

// MARK: - Preview
/// Shows both contexts for comparison
#Preview {
    VStack(spacing: 40) {
        // Calendar context (no header above)
        VStack(spacing: 0) {
            Text("Calendar Tab")
                .font(.caption)
                .foregroundColor(.gray)
            LessonPlanCardsView(
                entry: CalendarEntry.placeholders.first!,
                showSubmitFeedback: false,
                onSubmitFeedback: nil,
                hasHeaderAbove: false  // ✅ Rounded first card
            )
        }
        
        Divider()
        
        // Today context (header above)
        VStack(spacing: 0) {
            Text("Today Tab (with DateHeader)")
                .font(.caption)
                .foregroundColor(.gray)
            LessonPlanCardsView(
                entry: CalendarEntry.placeholders.first!,
                showSubmitFeedback: true,
                onSubmitFeedback: { print("Feedback") },
                hasHeaderAbove: true  // ✅ Flat first card
            )
        }
    }
    .padding()
    .background(MountainlandColors.platinum)
}
