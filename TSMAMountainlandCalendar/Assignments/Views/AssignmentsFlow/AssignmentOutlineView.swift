//
//  AssignmentOutlineView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/10/25.
//

import SwiftUI

// MARK: - Assignment Outline View
/// Detailed assignment view that pops up showing full description, when you tap on an assignment in any list.
/// Presents assignment content in a formatted, readable layout with markdown support
/// Appears as a sheet when tapping assignments in lists
/// When users see this when they've tapped an assignment from a list and want to read the full instructions, see the due date clearly, and easily mark it as complete without going back to the list.
struct AssignmentOutlineView: View {
    // MARK: - Properties
    let assignment: Assignment          // The assignment data to display
    let isCompleted: Bool               // Current completion status for visual feedback
    let onToggleComplete: () -> Void    // Closure to toggle completion status
    @Environment(\.dismiss) private var dismiss // Environment value for closing the sheet
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // MARK: - Assignment Header
                    /// Prominent display of assignment title and key metadata
                    VStack(alignment: .leading, spacing: 8) {
                        // MARK: - Assignment Title
                        /// Main assignment name in large, bold typography
                        Text(assignment.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(MountainlandColors.smokeyBlack)
                        
                        // MARK: - Assignment Metadata Row
                        /// Horizontal layout with due date and type badge
                        HStack {
                            Text("Due: \(assignment.formattedDueDate)")  // Formatted due date
                            Spacer()  // Pushes type badge to trailing edge
                            // MARK: - Assignment Type Badge
                            /// Colored badge showing assignment category
                            Text(assignment.assignmentType.rawValue.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(MountainlandColors.burgundy1.opacity(0.1))  // Subtle brand color
                                .foregroundColor(MountainlandColors.burgundy1)
                                .cornerRadius(4)
                        }
                        .font(.subheadline)
                        .foregroundColor(MountainlandColors.battleshipGray)
                    }
                    
                    // MARK: - Assignment Description
                    /// Main content area displaying markdown-formatted assignment details
                    /// Converts markdown to formatted text with proper styling
                    Text(attributedString)
                        .padding(.top, 8)  // Extra spacing from header
                }
                .padding()  // Content area padding
            }
            // MARK: - Bottom Action Bar
            /// Fixed completion button that stays visible while scrolling
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Divider()  // Visual separation from content
                    
                    // MARK: - Completion Toggle Button
                    /// Large, prominent button for marking assignment complete/incomplete
                    Button(action: {
                        onToggleComplete()  // Toggles completion status
                        // ✅ FIXED: Dismiss after toggling
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title2)  // Large icon for visibility
                            Text(isCompleted ? "Completed" : "Mark Complete")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)  // Full width button
                        .padding()
                        .background(isCompleted ? MountainlandColors.pigmentGreen : MountainlandColors.burgundy1)
                        .cornerRadius(10)
                    }
                    .padding()  // Button container padding
                }
                .background(MountainlandColors.white)  // Clean white background
            }
            .navigationTitle("Assignment")  // Screen title
            .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar
            .toolbar {
                // MARK: - Done Button
                /// Easy dismissal button in navigation bar
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()  // Closes the assignment detail sheet
                    }
                    .foregroundColor(MountainlandColors.burgundy1)  // Brand color
                }
            }
        }
    }
    
    // MARK: - Markdown Processing
    /// Converts markdown-formatted assignment description to styled text
    /// Provides rich text formatting for headings, lists, and emphasis
    private var attributedString: AttributedString {
        do {
            return try AttributedString(markdown: assignment.markdownDescription)
        } catch {
            // MARK: - Error Fallback
            /// Shows error message if markdown parsing fails
            return AttributedString("Error displaying assignment: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview
/// Xcode preview showing assignment detail view with sample data
/// Demonstrates the complete assignment outline with formatted content
#Preview {
    AssignmentOutlineView(
        assignment: Assignment.placeholder,
        isCompleted: false,
        onToggleComplete: {
            print("Toggled completion")
        }
    )
}
