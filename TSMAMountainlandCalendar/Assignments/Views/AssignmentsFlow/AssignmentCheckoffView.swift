//
//  AssignmentCheckoffView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Assignment Checkoff View
/// Displays assignment categories for a specific course section
/// Each category is a big tappable card that takes them to the detailed list of assignments.
/// Allows students to navigate to detailed assignment lists for each category
struct AssignmentCheckoffView: View {
    // MARK: - Properties
    let courseSection: CurriculumModule  // The course module being displayed
    @Environment(AssignmentsViewModel.self) private var viewModel  // Shared assignments data manager
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Header Section
                /// Course title displayed prominently at top of screen
                /// Uses centered alignment for clear visual hierarchy
                Text("\(courseSection.id) \(courseSection.title)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(MountainlandColors.smokeyBlack)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                
                // MARK: - Assignment Types Card Container
                /// Vertical stack of assignment category cards with dividers
                /// Provides clean, card-based navigation to assignment details
                VStack(spacing: 0) {
                    // Create assignment type cards with index for divider placement
                    ForEach(Array(courseSection.assignmentTypes.enumerated()), id: \.element.id) { index, assignmentType in
                        AssignmentTypeSummaryCard(
                            assignmentType: assignmentType,
                            onSelect: {
                                // Navigate to detailed assignment list when card is tapped
                                viewModel.selectAssignmentType(assignmentType)
                            }
                        )
                        
                        // Add divider between items (not after last one)
                        /// Prevents unnecessary divider after the final card
                        if index < courseSection.assignmentTypes.count - 1 {
                            Divider()
                                .background(MountainlandColors.smokeyBlack)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .background(MountainlandColors.white)  // Card background color
                .cornerRadius(12)  // Rounded card corners
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)  // Subtle card shadow
            }
            .padding()  // Outer padding for content
        }
        .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar
        .background(MountainlandColors.platinum.ignoresSafeArea())  // Page background color
    }
}

// MARK: - Assignment Type Summary Card
/// Individual card representing an assignment category (Labs, Challenges, etc.)
/// Tappable card that navigates to detailed assignment list for that category
struct AssignmentTypeSummaryCard: View {
    // MARK: - Properties
    let assignmentType: AssignmentTypeSummary  // The assignment category data to display
    let onSelect: () -> Void  // Closure called when card is tapped
    
    // MARK: - Computed Properties
    /// Determines completion icon based on whether all assignments are done
    /// Shows filled checkmark for complete, empty circle for incomplete
    private var completionIcon: String {
        assignmentType.isComplete ? "checkmark.circle.fill" : "circle"
    }
    
    /// Determines color for completion status
    /// Green for complete categories, gray for incomplete
    private var completionColor: Color {
        assignmentType.isComplete ? MountainlandColors.pigmentGreen : MountainlandColors.battleshipGray
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                // MARK: - Navigation Chevron
                /// Indicates this card is tappable and leads to another screen
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(MountainlandColors.smokeyBlack)
                    .frame(width: 20)  // Fixed width for consistent alignment
                
                // MARK: - Category Icon
                /// Folder icon representing assignment category
                /// Uses burgundy color with transparency for visual appeal
                Image(systemName: "folder.fill")
                    .foregroundColor(MountainlandColors.burgundy1.opacity(0.6))
                
                // MARK: - Category Title
                /// Display name of assignment category (e.g., "Labs & Projects")
                /// Uses medium font weight for clear hierarchy
                Text(assignmentType.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(MountainlandColors.smokeyBlack)
                
                Spacer()  // Pushes content to leading edge
            }
            .padding(.vertical, 88)  // Tall padding for large tap target
            .padding(.horizontal, 24)  // Side padding for content spacing
            .contentShape(Rectangle())  // Ensures entire area is tappable
            .background(Color.red)  // TEMPORARY: Visual debug background
        }
        .buttonStyle(PlainButtonStyle())  // Removes default button styling
    }
}

// MARK: - Preview
/// Xcode preview for design and layout testing
/// Shows the view with sample curriculum module data
#Preview {
    AssignmentCheckoffView(
        courseSection: CurriculumModule(
            id: "03",
            title: "Networking & Data Storage",
            dateRange: "Oct 1 - Nov 15",
            assignmentTypes: [
                AssignmentTypeSummary(
                    id: "labs",
                    title: "Labs & Projects",
                    completedCount: 0,
                    totalCount: 14,
                    assignments: []
                ),
                AssignmentTypeSummary(
                    id: "challenges",
                    title: "Code Challenges",
                    completedCount: 28,
                    totalCount: 28,
                    assignments: []
                ),
                AssignmentTypeSummary(
                    id: "vocab",
                    title: "Vocab Quiz",
                    completedCount: 0,
                    totalCount: 1,
                    assignments: []
                )
            ]
        )
    )
    .environment(AssignmentsViewModel())  // Provides shared view model for preview
}
