//
//  SubmitFeedbackView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

// *Submit Feedback View
/// Pop-up form that allows students to submit feedback about lessons
/// Triggered from the TodayView “Submit Feedback” button
/// Collects information on what worked well, confusion points, and improvement suggestions
/// Validates fields before allowing submission
import SwiftUI

struct SubmitFeedbackView: View {
    
    // *State / Properties
    @State private var selectedLessonID: String = ""    // Currently selected lesson from picker
    @State private var whatWentWell: String = ""        // Positive feedback text
    @State private var stillConfused: String = ""       // Areas needing clarification
    @State private var suggestions: String = ""         // Improvement or activity suggestions
    @Environment(\.dismiss) private var dismiss          // Dismisses the view when feedback is submitted or canceled
    
    // *Constants
    /// Available lesson options for feedback picker
    private let lessonOptions = ["SF25", "SF26", "SF27", "SF28"]
    
    // *Computed Properties
    /// Checks if all required fields have content
    /// Returns true only when a lesson is selected and all text fields are non-empty
    private var allFieldsFilled: Bool {
        !selectedLessonID.isEmpty &&
        !whatWentWell.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !stillConfused.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !suggestions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // *Body
    /// Main layout for the feedback form
    /// Uses NavigationStack for navigation controls and toolbar actions
    var body: some View {
        NavigationStack {
            
            // *Feedback Form
            /// Form with separate sections for each feedback category
            Form {
                
                // *Lesson Selection Section
                /// Picker allowing student to select which lesson feedback applies to
                Section(header: Text("Lesson Feedback")) {
                    Picker("Select Lesson", selection: $selectedLessonID) {
                        Text("Select a lesson").tag("")  // Placeholder option
                        ForEach(lessonOptions, id: \.self) { lessonID in
                            Text(lessonID).tag(lessonID)  // Available lessons
                        }
                    }
                }
                
                // *Positive Feedback Section
                /// Text editor for describing what went well in the lesson
                Section(header: Text("What went well in today's lesson?")) {
                    TextEditor(text: $whatWentWell)
                        .frame(minHeight: 100)  // Ensure enough space for text input
                }
                
                // *Confusion Points Section
                /// Text editor for documenting points that need clarification
                Section(header: Text("What are you still confused about?")) {
                    TextEditor(text: $stillConfused)
                        .frame(minHeight: 100)
                }
                
                // *Suggestions Section
                /// Text editor for activity suggestions or lesson improvements
                Section(header: Text("What suggestions for activities or changes to the lesson do you have?")) {
                    TextEditor(text: $suggestions)
                        .frame(minHeight: 100)
                }
                
                // *Submit Button Section
                /// Centered submit button with validation, styling, and tap action
                HStack {
                    Spacer() // Left spacer for centering
                    
                    Button(action: {
                        // Currently dismisses view; future version will make API call
                        dismiss()
                    }) {
                        // *Button Content
                        /// HStack with feedback icon and label
                        HStack {
                            Image(systemName: "text.bubble")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Submit Feedback")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(allFieldsFilled ? .white : Color.gray.opacity(0.8)) // Enabled/disabled color
                        .frame(width: 332, height: 56)                                         // Fixed size
                        .background(allFieldsFilled ? MountainlandColors.burgundy1 : Color.gray.opacity(0.3)) // Enabled/disabled background
                        .cornerRadius(12)                                                       // Rounded corners
                        .shadow(
                            color: allFieldsFilled ? .black.opacity(0.15) : .clear,           // Shadow only when enabled
                            radius: allFieldsFilled ? 4 : 0,
                            x: 0,
                            y: allFieldsFilled ? 2 : 0
                        )
                    }
                    .disabled(!allFieldsFilled)  // Disable button until all fields are filled
                    
                    Spacer() // Right spacer for centering
                }
                .listRowBackground(Color.clear)  // Remove default section background
                .listRowInsets(EdgeInsets())     // Remove default section padding
            }
            .navigationTitle("Submit Feedback")           // Navigation bar title
            .navigationBarTitleDisplayMode(.inline)      // Compact inline title
            
            // *Navigation Toolbar
            /// Cancel button for dismissing feedback form without submitting
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(MountainlandColors.burgundy1) // Brand color
                }
            }
        }
    }
}


#Preview {
    SubmitFeedbackView()
}
