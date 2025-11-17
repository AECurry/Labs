//
//  LessonOutlineView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

// MARK: - Lesson Outline View
/// Modal view that displays formatted lesson outline content with Markdown support
/// This is the "lessons details' screen that pops up when the user taps on a lesson topic in the calendar.
/// This is essentially the digital lesson planner that teachers can fill with formatted content that students can easily read and follow.
struct LessonOutlineView: View {
    // MARK: - Properties
    let lessonOutline: String       // The lesson outline text content (supports Markdown)
    @Environment(\.dismiss) private var dismiss  // Environment dismiss action for modal closure
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: - Content Display
                /// Displays lesson outline with Markdown formatting applied
                Text(attributedString)
                    .padding()  // Padding around the text content
            }
            .navigationTitle("Lesson Outline")  // Screen title
            .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar
            .toolbar {
                // MARK: - Navigation Toolbar
                /// Close button to dismiss the modal view
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()  // Close the lesson outline view
                    }
                    .foregroundColor(MountainlandColors.burgundy1)  // Brand color
                }
            }
        }
    }
    
    // MARK: - Markdown Processing
    /// Converts plain text with Markdown into formatted AttributedString
    /// Handles headers, lists, bold, italic, and other Markdown formatting
    private var attributedString: AttributedString {
        do {
            // Attempt to parse Markdown and create formatted text
            return try AttributedString(markdown: lessonOutline)
        } catch {
            // Fallback display if Markdown parsing fails
            return AttributedString("Error displaying lesson outline: \(error.localizedDescription)")
        }
    }
}

#Preview {
    LessonOutlineView(lessonOutline: """
    # Functions & Closures
    
    ## Learning Objectives
    - Understand function syntax in Swift
    - Master closure expressions
    - Learn about higher-order functions
    
    ## Topics Covered
    1. Function Declaration
    2. Parameters and Return Types
    3. Closure Syntax
    4. Trailing Closures
    5. Capturing Values
    """)
}
