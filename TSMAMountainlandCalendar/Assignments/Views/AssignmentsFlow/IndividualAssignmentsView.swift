//
//  IndividualAssignmentsView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Individual Assignments View
/// Creates the screen that shows all assignments in one category
/// Displays each assignment as a card with a big checkbox to mark it complete
/// Used after tapping on an assignment type card to see the full list
struct IndividualAssignmentsView: View {
    // MARK: - Properties
    let courseSection: CurriculumModule        // The course module containing these assignments
    let assignmentType: AssignmentTypeSummary  // The specific assignment category being viewed
    @Environment(AssignmentsViewModel.self) private var viewModel  // Shared assignments state manager
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // MARK: - Header Section
                /// Shows course title and assignment category for context
                VStack(alignment: .leading, spacing: 8) {
                    // MARK: - Course Title
                    /// Main course name in large, bold typography
                    Text(courseSection.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(MountainlandColors.smokeyBlack)
                    
                    // MARK: - Assignment Category
                    /// Specific assignment type in brand burgundy color
                    Text(assignmentType.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(MountainlandColors.burgundy1)
                }
                
                // MARK: - Assignments List
                /// Scrollable list of individual assignments with completion checkboxes
                /// Uses LazyVStack for efficient rendering of potentially long lists
                LazyVStack(alignment: .leading, spacing: 12) {
                    // MARK: - Assignment Rows
                    /// Creates a checkbox row for each assignment in the category
                    ForEach(assignmentType.assignments) { assignment in
                        AssignmentCheckboxRow(
                            assignment: assignment,
                            onToggle: {
                                // Toggle completion status in the shared view model
                                viewModel.toggleAssignmentCompletion(assignment)
                            }
                        )
                    }
                }
            }
            .padding()  // Outer padding for content
        }
        .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar
        .background(MountainlandColors.platinum.ignoresSafeArea())  // Page background
    }
}

// MARK: - Assignment Checkbox Row
/// Individual row showing an assignment with completion checkbox
/// Features strikethrough text for completed assignments and visual feedback
struct AssignmentCheckboxRow: View {
    // MARK: - Properties
    let assignment: Assignment  // The assignment data to display
    let onToggle: () -> Void    // Closure called when checkbox is tapped
    
    // MARK: - Computed Properties
    /// Determines checkbox icon based on completion status
    /// Filled checkmark circle for complete, empty circle for incomplete
    private var completionIcon: String {
        assignment.isCompleted ? "checkmark.circle.fill" : "circle"
    }
    
    /// Determines checkbox color based on completion status
    /// Green for complete assignments, gray for incomplete
    private var completionColor: Color {
        assignment.isCompleted ? MountainlandColors.pigmentGreen : MountainlandColors.battleshipGray
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // MARK: - Completion Checkbox
            /// Large, tappable checkbox for marking assignment completion
            Button(action: onToggle) {
                Image(systemName: completionIcon)
                    .font(.title2)  // Larger icon for easy tapping
                    .foregroundColor(completionColor)
            }
            .buttonStyle(PlainButtonStyle())  // Removes default button styling
            
            // MARK: - Assignment Details
            /// Text content showing assignment title and identifier
            VStack(alignment: .leading, spacing: 4) {
                // MARK: - Assignment Title
                /// Main assignment name with strikethrough when completed
                Text(assignment.title)
                    .font(.body)
                    .foregroundColor(assignment.isCompleted ? MountainlandColors.battleshipGray : MountainlandColors.smokeyBlack)
                    .strikethrough(assignment.isCompleted)  // Visual completion indicator
                
                // MARK: - Assignment ID (Conditional)
                /// Course-specific identifier shown below title when available
                if !assignment.assignmentID.isEmpty {
                    Text(assignment.assignmentID)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(MountainlandColors.burgundy1)  // Brand color
                }
            }
            
            Spacer()  // Pushes content to leading edge
        }
        .padding()  // Internal padding for card content
        .background(MountainlandColors.adaptiveCard)  // Card background
        .cornerRadius(8)  // Slightly rounded corners
    }
}

// MARK: - Preview
/// Xcode preview showing the individual assignments view with sample data
/// Demonstrates both completed and incomplete assignments in a list
#Preview {
    IndividualAssignmentsView(
        courseSection: CurriculumModule(
            id: "02",
            title: "Tables & Persistence",
            dateRange: "Oct 1 - Nov 15",
            assignmentTypes: []  // Empty since we're providing specific assignmentType
        ),
        assignmentType: AssignmentTypeSummary(
            id: "labs",
            title: "Labs & Projects",
            completedCount: 0,
            totalCount: 14,
            assignments: [
                // MARK: - Incomplete Assignment Preview
                Assignment(
                    assignmentID: "TP02",
                    title: "Lab: List.Form",
                    dueDate: Date(),
                    lessonID: "02",
                    assignmentType: .lab,
                    markdownDescription: "# List.Form Lab",
                    completionDate: nil  // Not completed
                ),
                // MARK: - Completed Assignment Preview
                Assignment(
                    assignmentID: "TP03",
                    title: "Lab: Navigation",
                    dueDate: Date(),
                    lessonID: "02",
                    assignmentType: .lab,
                    markdownDescription: "# Navigation Lab",
                    completionDate: Date() // This one is completed - shows strikethrough
                )
            ]
        )
    )
    .environment(AssignmentsViewModel())  // Provides shared view model for preview
}
