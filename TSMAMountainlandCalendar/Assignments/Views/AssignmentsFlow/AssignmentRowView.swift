//
//  AssignmentRowView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Assignment Row View
/// Displays a single assignment in a card-style row with completion toggle
/// Shows assignment details, due date, overdue status, and type badge
/// Lets students mark assignments as complete with a tap.
/// The entire card is tappable to see assignment details

struct AssignmentRowView: View {
    // MARK: - Properties
    let assignment: Assignment      // The assignment data to display
    let onToggleComplete: () -> Void // Closure called when completion is toggled
    let onTap: () -> Void           // Closure called when row is tapped for details
    
    // MARK: - Computed Properties
    /// Determines if assignment is overdue (past due and not completed)
    /// Used to apply visual styling for overdue assignments
    private var isOverdue: Bool {
        !assignment.isCompleted && assignment.dueDate < Date()
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Completion Toggle Button
            /// Circular button that toggles assignment completion status
            /// Shows filled checkmark for completed, empty circle for incomplete
            Button(action: onToggleComplete) {
                Image(systemName: assignment.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(assignment.isCompleted ? MountainlandColors.pigmentGreen : MountainlandColors.battleshipGray)
            }
            .buttonStyle(PlainButtonStyle())  // Removes default button styling
            
            // MARK: - Assignment Information Stack
            /// Primary assignment details: title, ID, due date, and overdue status
            VStack(alignment: .leading, spacing: 4) {
                // MARK: - Assignment Title
                /// Main assignment name with strikethrough when completed
                Text(assignment.title)
                    .font(.headline)
                    .strikethrough(assignment.isCompleted)  // Visual completion indicator
                    .foregroundColor(assignment.isCompleted ? MountainlandColors.battleshipGray : MountainlandColors.smokeyBlack)
                
                // MARK: - Assignment Metadata Row
                /// Horizontal stack with assignment ID, due date, and overdue indicator
                HStack {
                    // MARK: - Assignment ID
                    /// Course-specific identifier in brand burgundy color
                    Text(assignment.assignmentID)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(MountainlandColors.burgundy1)
                    
                    // MARK: - Due Date
                    /// Formatted due date with red color for overdue assignments
                    Text(assignment.formattedDueDate)
                        .font(.caption)
                        .foregroundColor(isOverdue ? .red : MountainlandColors.battleshipGray)
                    
                    // MARK: - Overdue Badge (Conditional)
                    /// Red "Overdue" badge shown only for past-due incomplete assignments
                    if isOverdue {
                        Text("Overdue")
                            .font(.caption2)
                            .foregroundColor(.red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.1))  // Subtle red background
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()  // Pushes type badge to trailing edge
            
            // MARK: - Assignment Type Badge
            /// Colored badge showing assignment category (Lab, Project, etc.)
            /// Uses semi-transparent burgundy background for visual distinction
            Text(assignment.assignmentType.rawValue.capitalized)
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(MountainlandColors.burgundy1.opacity(0.1))  // Subtle brand color
                .foregroundColor(MountainlandColors.burgundy1)  // Brand text color
                .cornerRadius(4)
        }
        .padding()  // Internal padding for content
        .background(MountainlandColors.adaptiveCard)  // Card background color
        .cornerRadius(12)  // Rounded card corners
        .overlay(
            // MARK: - Card Border
            /// Subtle border around the card for definition
            RoundedRectangle(cornerRadius: 12)
                .stroke(MountainlandColors.platinum, lineWidth: 1)
        )
        // MARK: - Tap Gesture
        /// Makes entire card tappable to show assignment details
        /// Separate from completion toggle for clear user interaction
        .onTapGesture(perform: onTap)
    }
}

// MARK: - Preview
/// Xcode preview showing three assignment states:
/// - Normal (upcoming due date)
/// - Overdue (past due date, incomplete)
/// - Completed (with completion date)
#Preview {
    VStack {
        // MARK: - Normal Assignment Preview
        /// Assignment with future due date, not completed
        AssignmentRowView(
            assignment: Assignment(
                assignmentID: "TP02",
                title: "List.Form Lab",
                dueDate: Date().addingTimeInterval(86400), // Tomorrow
                lessonID: "02",
                assignmentType: .lab,
                markdownDescription: "# List.Form Lab\n\nPractice creating lists and forms in SwiftUI."
            ),
            onToggleComplete: {
                print("Toggled completion")
            },
            onTap: {
                print("Tapped assignment")
            }
        )
        
        // MARK: - Overdue Assignment Preview
        /// Assignment with past due date, not completed - shows overdue styling
        AssignmentRowView(
            assignment: Assignment(
                assignmentID: "TP01",
                title: "Overdue Assignment",
                dueDate: Date().addingTimeInterval(-86400), // Yesterday
                lessonID: "02",
                assignmentType: .project,
                markdownDescription: "# Overdue Assignment\n\nThis assignment is overdue."
            ),
            onToggleComplete: {
                print("Toggled completion")
            },
            onTap: {
                print("Tapped assignment")
            }
        )
        
        // MARK: - Completed Assignment Preview
        /// Assignment with completion date - shows strikethrough and green checkmark
        AssignmentRowView(
            assignment: Assignment(
                assignmentID: "TP03",
                title: "Completed Assignment",
                dueDate: Date().addingTimeInterval(86400 * 3), // 3 days from now
                lessonID: "02",
                assignmentType: .codeChallenge,
                markdownDescription: "# Completed Assignment\n\nThis assignment is already done.",
                completionDate: Date()
            ),
            onToggleComplete: {
                print("Toggled completion")
            },
            onTap: {
                print("Tapped assignment")
            }
        )
    }
    .padding()  // Preview container padding
    .background(MountainlandColors.platinum)  // Preview background matching app
}
