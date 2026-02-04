//
//  IndividualAssignmentsView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Individual Assignments View
/// Detailed screen displaying all assignments within a specific category (Labs, Projects, etc.)
/// Provides a clean interface for viewing and toggling assignment completion status
/// Used after users tap on an assignment category card to see the full list of assignments
/// Implements proper Swift Concurrency for API interactions with user-friendly error handling
struct IndividualAssignmentsView: View {
    // MARK: - Properties
    
    /// The course module containing the assignments being displayed
    /// Provides contextual information about the academic section and date range
    let courseSection: CurriculumModule
    
    /// The specific assignment category being viewed (e.g., "Labs & Projects")
    /// Contains the array of individual assignments to display in checkbox format
    let assignmentType: AssignmentTypeSummary
    
    /// Shared ViewModel for managing assignment data and API interactions
    /// Provides centralized state management for assignment completion and loading states
    @Environment(AssignmentsViewModel.self) private var viewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // MARK: - Header Section
                /// Prominent title area showing course and assignment category for clear context
                /// Uses hierarchical typography for visual clarity and information hierarchy
                VStack(alignment: .leading, spacing: 8) {
                    // MARK: - Course Title
                    /// Main course name displayed in large, bold typography for primary identification
                    /// Provides academic context for the assignments being viewed
                    Text(courseSection.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(MountainlandColors.smokeyBlack)
                    
                    // MARK: - Assignment Category
                    /// Specific assignment type displayed in brand burgundy color for visual distinction
                    /// Helps users understand which category of assignments they are viewing
                    Text(assignmentType.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(MountainlandColors.burgundy1)
                }
                
                // MARK: - Assignments List Container
                /// Scrollable container for assignment rows with efficient LazyVStack rendering
                /// Uses lazy loading for optimal performance with potentially long assignment lists
                /// Provides consistent spacing between individual assignment checkbox rows
                LazyVStack(alignment: .leading, spacing: 12) {
                    // MARK: - Assignment Rows Loop
                    /// Iterates through each assignment in the category to create interactive rows
                    /// Each row includes a tappable checkbox and assignment details
                    /// Implements proper Swift Concurrency for API completion toggling
                    ForEach(assignmentType.assignments) { assignment in
                        AssignmentCheckboxRow(
                            assignment: assignment,
                            onToggle: {
                                // MARK: - Asynchronous Completion Toggle
                                /// Wraps the async ViewModel call in a Task to handle concurrency properly
                                /// Prevents "async call in non-async context" compiler errors
                                /// Ensures UI remains responsive while API operation completes
                                Task {
                                    await viewModel.toggleAssignmentCompletion(assignment)
                                }
                            }
                        )
                    }
                }
            }
            .padding()  // Outer padding for comfortable content spacing
        }
        .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar for focused content
        .background(MountainlandColors.platinum.ignoresSafeArea())  // Consistent app background
    }
}

// MARK: - Assignment Checkbox Row Component
/// Reusable row component displaying individual assignments with completion toggle functionality
/// Features visual feedback for completion status with strikethrough text and color changes
/// Provides clear affordance for marking assignments complete/incomplete with large tap targets
struct AssignmentCheckboxRow: View {
    // MARK: - Properties
    
    /// The assignment data to display in this row
    /// Contains title, ID, completion status, and other metadata for display
    let assignment: Assignment
    
    /// Closure called when the completion checkbox is tapped
    /// Handles the API call to update completion status on the server
    let onToggle: () -> Void
    
    // MARK: - Computed Properties
    
    /// Determines the appropriate SF Symbol icon based on assignment completion status
    /// Returns "checkmark.circle.fill" for completed assignments, "circle" for incomplete
    /// Provides clear visual feedback for current completion state
    private var completionIcon: String {
        assignment.isCompleted ? "checkmark.circle.fill" : "circle"
    }
    
    /// Determines the appropriate color for the completion icon based on assignment status
    /// Returns green for completed assignments, gray for incomplete assignments
    /// Uses brand color palette for consistent visual design throughout the app
    private var completionColor: Color {
        assignment.isCompleted ? MountainlandColors.pigmentGreen : MountainlandColors.battleshipGray
    }
    
    // MARK: - Body
    var body: some View {
        // MARK: - Row Container
        /// Horizontal stack arranging checkbox, assignment details, and spacing
        /// Uses top alignment to handle multi-line assignment titles gracefully
        /// Provides generous spacing between elements for clear visual separation
        HStack(alignment: .top, spacing: 16) {
            // MARK: - Completion Checkbox Button
            /// Large, tappable checkbox for marking assignment completion
            /// Uses SF Symbol icons with appropriate colors based on completion status
            /// Implements PlainButtonStyle to remove default iOS button styling
            Button(action: onToggle) {
                Image(systemName: completionIcon)
                    .font(.title2)  // Large icon size for easy tapping
                    .foregroundColor(completionColor)  // Color-coded completion status
            }
            .buttonStyle(PlainButtonStyle())  // Clean, minimal button appearance
            
            // MARK: - Assignment Details Stack
            /// Vertical stack containing assignment title and optional identifier
            /// Provides clear typographic hierarchy with appropriate text styling
            /// Implements strikethrough effect for completed assignments as visual indicator
            VStack(alignment: .leading, spacing: 4) {
                // MARK: - Assignment Title
                /// Primary assignment name with conditional strikethrough for completed items
                /// Uses appropriate text colors based on completion status for visual clarity
                Text(assignment.title)
                    .font(.body)
                    .foregroundColor(assignment.isCompleted ?
                        MountainlandColors.battleshipGray : MountainlandColors.smokeyBlack)
                    .strikethrough(assignment.isCompleted)  // Visual completion indicator
                
                // MARK: - Assignment ID (Conditional)
                /// Course-specific identifier shown when available
                /// Uses smaller font size and brand burgundy color for visual distinction
                /// Hidden when assignment ID is empty to maintain clean layout
                if !assignment.assignmentID.isEmpty {
                    Text(assignment.assignmentID)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(MountainlandColors.burgundy1)
                }
            }
            
            Spacer()  // Pushes content to leading edge for clean alignment
        }
        .padding()  // Internal padding for comfortable content spacing
        .background(MountainlandColors.adaptiveCard)  // Card background with dark mode support
        .cornerRadius(8)  // Subtle rounding for modern card appearance
    }
}
