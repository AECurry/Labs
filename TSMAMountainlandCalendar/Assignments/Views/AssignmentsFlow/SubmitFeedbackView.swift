//
//  SubmitFeedbackView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

/// Pop-up form that comes from Views/Today/TodayView/Submit Form Button at the bottom of the screen
/// Allows students to provide feedback on what worked, confusion points, and suggestions
struct SubmitFeedbackView: View {
    // MARK: - Properties
    @State private var selectedLessonID: String = ""    // Currently selected lesson from picker
    @State private var whatWentWell: String = ""        // Positive feedback about the lesson
    @State private var stillConfused: String = ""       // Areas that need clarification
    @State private var suggestions: String = ""         // Improvement suggestions
    @Environment(\.dismiss) private var dismiss          // Environment value for view dismissal
    
    // MARK: - Constants
    /// Available lesson options for feedback selection
    private let lessonOptions = ["SF25", "SF26", "SF27", "SF28"]
    
    // MARK: - Computed Properties
    /// Validates that all required form fields contain content
    /// Returns true when lesson is selected and all text fields have non-whitespace content
    private var allFieldsFilled: Bool {
        !selectedLessonID.isEmpty &&
        !whatWentWell.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !stillConfused.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !suggestions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            // MARK: - Feedback Form
            /// Main form container with sections for each feedback category
            Form {
                // MARK: - Lesson Selection Section
                /// Picker for selecting which lesson the feedback applies to
                Section(header: Text("Lesson Feedback")) {
                    Picker("Select Lesson", selection: $selectedLessonID) {
                        Text("Select a lesson").tag("")  // Default placeholder option
                        ForEach(lessonOptions, id: \.self) { lessonID in
                            Text(lessonID).tag(lessonID) // Available lesson options
                        }
                    }
                }
                
                // MARK: - Positive Feedback Section
                /// Text area for describing what worked well in the lesson
                Section(header: Text("What went well in today's lesson?")) {
                    TextEditor(text: $whatWentWell)
                        .frame(minHeight: 100)  // Minimum height for adequate text entry space
                }
                
                // MARK: - Confusion Points Section
                /// Text area for documenting areas that need further clarification
                Section(header: Text("What are you still confused about?")) {
                    TextEditor(text: $stillConfused)
                        .frame(minHeight: 100)  // Minimum height for adequate text entry space
                }
                
                // MARK: - Suggestions Section
                /// Text area for improvement suggestions and activity ideas
                Section(header: Text("What suggestions for activities or changes to the lesson do you have?")) {
                    TextEditor(text: $suggestions)
                        .frame(minHeight: 100)  // Minimum height for adequate text entry space
                }
                
                // MARK: - Submit Button Section
                /// Centered submit button with validation and custom styling
                HStack {
                    Spacer()  // Left spacer for centering
                    
                    Button(action: {
                        // In the future, this will make an API call
                        dismiss()  // Currently dismisses view, will be replaced with API call
                    }) {
                        // MARK: - Button Content
                        /// Custom styled button with icon and text
                        HStack {
                            Image(systemName: "text.bubble")  // Feedback icon
                                .font(.system(size: 18, weight: .semibold))
                            Text("Submit Feedback")  // Button label
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(allFieldsFilled ? .white : Color.gray.opacity(0.8))  // White when enabled, gray when disabled
                        .frame(width: 332, height: 56)  // Fixed button dimensions
                        .background(allFieldsFilled ? MountainlandColors.burgundy1 : Color.gray.opacity(0.3))  // Burgundy when enabled, light gray when disabled
                        .cornerRadius(12)  // Rounded corners
                        .shadow(
                            color: allFieldsFilled ? .black.opacity(0.15) : .clear,  // Shadow only when enabled
                            radius: allFieldsFilled ? 4 : 0,
                            x: 0,
                            y: allFieldsFilled ? 2 : 0
                        )
                    }
                    .disabled(!allFieldsFilled)  // Disable button until all fields are filled
                    
                    Spacer()  // Right spacer for centering
                }
                .listRowBackground(Color.clear)  // Remove default section background
                .listRowInsets(EdgeInsets())     // Remove default section padding
            }
            .navigationTitle("Submit Feedback")  // View title
            .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar title
            
            // MARK: - Navigation Toolbar
            /// Cancel button for dismissing the feedback form
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()  // Dismiss without submitting
                    }
                    .foregroundColor(MountainlandColors.burgundy1)  // Brand color for cancel button
                }
            }
        }
    }
}

#Preview {
    SubmitFeedbackView()
}
