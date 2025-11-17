//
//  AssignmentListView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Main View (Parent)
/// Displays a detailed list of assignments for a specific course section
/// Features collapsible sections, completion tracking, and assignment details
/// Students can tap assignments to see details and use checkboxes to mark them as complete.
/// This is the content that goes inside the AssignmentRowView

struct AssignmentListView: View {
    // MARK: - Properties
    let currentUser: Student                    // The student viewing the assignments
    let courseSection: CurriculumModule        // Course module containing the assignments
    @State private var viewModel = AssignmentListViewModel()  // Manages expansion and completion state
    @Environment(\.dismiss) private var dismiss // Environment value for closing the view
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header with Back Button and User Profile
                AssignmentListHeader(
                    currentUser: currentUser,
                    onDismiss: { dismiss() }
                )
                
                // MARK: - Course Title and Date Range
                AssignmentListCourseTitle(courseSection: courseSection)
                
                // MARK: - Scrollable Assignment Content
                AssignmentListContent(
                    courseSection: courseSection,
                    viewModel: viewModel
                )
            }
            .background(MountainlandColors.platinum.ignoresSafeArea())  // Page background
            .navigationBarHidden(true)  // Custom navigation bar implementation
        }
    }
}

// MARK: - View Model (Single Responsibility)
/// Manages the expansion state of assignment sections and completion tracking
/// Follows Single Responsibility Principle - only handles UI state, not business logic
@Observable
class AssignmentListViewModel {
    // MARK: - State Properties
    var expandedSections: Set<String> = []     // Tracks which assignment sections are expanded
    var completedAssignments: Set<String> = [] // Tracks which assignments are marked complete
    
    // MARK: - Section Management
    /// Toggles expansion state for an assignment section
    /// Opens collapsed sections and closes expanded ones
    func toggleSection(_ sectionId: String) {
        if expandedSections.contains(sectionId) {
            expandedSections.remove(sectionId)
        } else {
            expandedSections.insert(sectionId)
        }
    }
    
    /// Checks if a specific assignment section is currently expanded
    func isSectionExpanded(_ sectionId: String) -> Bool {
        expandedSections.contains(sectionId)
    }
    
    // MARK: - Completion Management
    /// Toggles completion status for a specific assignment
    /// Marks incomplete assignments as complete and vice versa
    func toggleAssignmentCompletion(_ assignmentId: String) {
        if completedAssignments.contains(assignmentId) {
            completedAssignments.remove(assignmentId)
        } else {
            completedAssignments.insert(assignmentId)
        }
    }
    
    /// Checks if a specific assignment is marked as complete
    func isAssignmentCompleted(_ assignmentId: String) -> Bool {
        completedAssignments.contains(assignmentId)
    }
}

// MARK: - Header Component (Single Responsibility)
/// Displays navigation back button and user profile circle
/// Handles dismiss action for returning to previous screen
struct AssignmentListHeader: View {
    // MARK: - Properties
    let currentUser: Student  // Current user for profile display
    let onDismiss: () -> Void // Closure called when back button is tapped
    
    // MARK: - Body
    var body: some View {
        HStack {
            // MARK: - Back Button
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            .padding(.leading, 8)
            
            Spacer()  // Pushes profile to trailing edge
            
            // MARK: - User Profile Circle
            UserProfileCircle(initials: currentUser.initials, size: 40)
                .padding(.trailing, 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 16)
    }
}

// MARK: - Reusable Profile Circle Component
/// Displays user initials in a circular profile avatar
/// Uses brand burgundy color for consistent styling
struct UserProfileCircle: View {
    // MARK: - Properties
    let initials: String  // User initials to display
    let size: CGFloat     // Diameter of the circle
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Circle()
                .fill(MountainlandColors.burgundy2)  // Brand color background
                .frame(width: size, height: size)
            
            Text(initials)
                .font(.system(size: size * 0.4, weight: .bold))  // Responsive text size
                .foregroundColor(.white)
        }
    }
}

// MARK: - Course Title Component (Single Responsibility)
/// Displays the course section title and date range
/// Provides clear context about which assignments are being viewed
struct AssignmentListCourseTitle: View {
    // MARK: - Properties
    let courseSection: CurriculumModule  // Course data for title and dates
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // MARK: - Course Title
            Text(courseSection.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(MountainlandColors.smokeyBlack)
            
            // MARK: - Date Range
            Text(courseSection.dateRange)
                .font(.subheadline)
                .foregroundColor(MountainlandColors.battleshipGray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)  // Full width alignment
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

// MARK: - Content Component (Single Responsibility)
/// Container for scrollable assignment content
/// Wraps the assignment card with proper padding and scrolling
struct AssignmentListContent: View {
    // MARK: - Properties
    let courseSection: CurriculumModule  // Course data to display
    @Bindable var viewModel: AssignmentListViewModel  // Shared state management
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Assignment Card
                AssignmentCard(
                    courseSection: courseSection,
                    viewModel: viewModel
                )
                .padding(.horizontal, 16)  // Side padding for card
            }
            .padding(.bottom, 24)  // Bottom padding for scroll content
        }
    }
}

// MARK: - Assignment Card Component
/// Container for all assignment sections with card styling
/// Applies background, corner radius, and shadow for elevated appearance
struct AssignmentCard: View {
    // MARK: - Properties
    let courseSection: CurriculumModule  // Course data containing assignments
    @Bindable var viewModel: AssignmentListViewModel  // Expansion state management
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Assignment Sections
            /// Creates a collapsible section for each assignment type
            ForEach(courseSection.assignmentTypes) { assignmentType in
                CollapsibleAssignmentSection(
                    assignmentType: assignmentType,
                    isExpanded: viewModel.isSectionExpanded(assignmentType.id),
                    onToggle: {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.toggleSection(assignmentType.id)
                        }
                    },
                    viewModel: viewModel
                )
            }
        }
        .background(MountainlandColors.white)  // Card background
        .cornerRadius(12)  // Rounded corners
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)  // Subtle shadow
        .frame(minHeight: 100)  // Minimum height for empty states
    }
}

// MARK: - Collapsible Section Component (Single Responsibility)
/// Individual expandable/collapsible section for an assignment type
/// Shows header when collapsed, reveals assignments when expanded
struct CollapsibleAssignmentSection: View {
    // MARK: - Properties
    let assignmentType: AssignmentTypeSummary  // Assignment category data
    let isExpanded: Bool                       // Current expansion state
    let onToggle: () -> Void                   // Closure to toggle expansion
    @Bindable var viewModel: AssignmentListViewModel  // Completion state management
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Section Header
            AssignmentSectionHeader(
                assignmentType: assignmentType,
                isExpanded: isExpanded,
                onToggle: onToggle
            )
            
            // MARK: - Section Content (Conditional)
            /// Only shows assignments when section is expanded
            if isExpanded {
                AssignmentSectionContent(
                    assignments: assignmentType.assignments,
                    viewModel: viewModel
                )
            }
        }
    }
}

// MARK: - Section Header Component
/// Tappable header for assignment sections with folder icon and chevron
/// Shows expansion state and provides toggle action
struct AssignmentSectionHeader: View {
    // MARK: - Properties
    let assignmentType: AssignmentTypeSummary  // Assignment category to display
    let isExpanded: Bool                       // Current expansion state
    let onToggle: () -> Void                   // Toggle expansion action
    
    // MARK: - Body
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                // MARK: - Expansion Chevron
                /// Points down when expanded, right when collapsed
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.caption)
                    .foregroundColor(MountainlandColors.smokeyBlack)
                    .frame(width: 24)  // Fixed width for consistent alignment
                
                // MARK: - Folder Icon
                Image(systemName: "folder.fill")
                    .foregroundColor(MountainlandColors.burgundy1.opacity(0.6))
                
                // MARK: - Section Title
                Text(assignmentType.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(MountainlandColors.smokeyBlack)
                
                Spacer()  // Pushes content to leading edge
            }
            .padding(.vertical, 40)  // Tall padding for large tap target
            .padding(.horizontal, 24)  // Side padding for content
            .contentShape(Rectangle())  // Makes entire area tappable
        }
        .buttonStyle(PlainButtonStyle())  // Removes default button styling
    }
}

// MARK: - Section Content Component
/// Displays the list of assignments when a section is expanded
/// Shows individual assignment rows with completion checkboxes
struct AssignmentSectionContent: View {
    // MARK: - Properties
    let assignments: [Assignment]              // Assignments to display
    @Bindable var viewModel: AssignmentListViewModel  // Completion state management
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Assignment Rows
            /// Creates a row for each assignment with completion toggle
            ForEach(assignments) { assignment in
                AssignmentRow(
                    assignment: assignment,
                    isCompleted: viewModel.isAssignmentCompleted(assignment.id.uuidString),
                    showDivider: assignment.id != assignments.last?.id,  // No divider after last item
                    onToggle: {
                        withAnimation(.spring(response: 0.2)) {
                            viewModel.toggleAssignmentCompletion(assignment.id.uuidString)
                        }
                    }
                )
            }
        }
    }
}

// MARK: - Assignment Row Component (Single Responsibility)
/// Individual row representing a single assignment
/// Shows assignment details and provides completion toggle and detail view
struct AssignmentRow: View {
    // MARK: - Properties
    let assignment: Assignment  // The assignment data to display
    let isCompleted: Bool       // Current completion status
    let showDivider: Bool       // Whether to show divider below this row
    let onToggle: () -> Void    // Closure to toggle completion status
    
    @State private var showingAssignmentOutline = false  // Controls detail sheet presentation
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Assignment Content Button
            /// Tapping the assignment content shows detailed outline
            Button(action: {
                showingAssignmentOutline = true
            }) {
                HStack(spacing: 12) {
                    AssignmentRowContent(assignment: assignment)
                    Spacer()  // Pushes checkbox to trailing edge
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
            .overlay(
                // MARK: - Completion Checkbox Overlay
                /// Positioned at trailing edge, overlays the content
                HStack {
                    Spacer()
                    AssignmentCheckbox(
                        isCompleted: isCompleted,
                        onToggle: onToggle
                    )
                    .padding(.trailing, 16)
                }
            )
            
            // MARK: - Row Divider (Conditional)
            /// Shows divider between rows, but not after the last one
            if showDivider {
                AssignmentRowDivider()
            }
        }
        // MARK: - Assignment Detail Sheet
        /// Presents assignment details when row is tapped
        .sheet(isPresented: $showingAssignmentOutline) {
            AssignmentOutlineView(
                assignment: assignment,
                isCompleted: isCompleted,
                onToggleComplete: onToggle
            )
        }
    }
}

// MARK: - Assignment Row Content Component
/// Displays the assignment ID, type, and title in a structured layout
/// Provides consistent formatting for all assignment rows
struct AssignmentRowContent: View {
    // MARK: - Properties
    let assignment: Assignment  // Assignment data to display
    
    // MARK: - Computed Properties
    /// Converts assignment type enum to display-friendly string
    private var assignmentTypeLabel: String {
        switch assignment.assignmentType {
        case .lab: return "Lab"
        case .project: return "Project"
        case .codeChallenge: return "Challenge"
        case .vocabQuiz: return "Quiz"
        case .reading: return "Reading"
        }
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - Assignment ID
            Text(assignment.assignmentID)
                .font(.system(size: 14))
                .foregroundColor(MountainlandColors.smokeyBlack)
                .frame(width: 50, alignment: .leading)  // Fixed width for alignment
            
            // MARK: - Assignment Type
            Text(assignmentTypeLabel + ":")
                .font(.system(size: 14))
                .foregroundColor(MountainlandColors.smokeyBlack)
                .frame(width: 60, alignment: .leading)  // Fixed width for alignment
            
            // MARK: - Assignment Title
            Text(assignment.title)
                .font(.system(size: 14))
                .foregroundColor(MountainlandColors.smokeyBlack)
        }
    }
}

// MARK: - Reusable Checkbox Component (Open/Closed Principle)
/// Toggle-able checkbox for marking assignment completion
/// Follows Open/Closed Principle - extendable without modification
struct AssignmentCheckbox: View {
    // MARK: - Properties
    let isCompleted: Bool  // Current completion state
    let onToggle: () -> Void  // Toggle action
    
    // MARK: - Body
    var body: some View {
        Button(action: onToggle) {
            Image(systemName: isCompleted ? "checkmark.square.fill" : "square")
                .font(.title3)
                .foregroundColor(isCompleted ? MountainlandColors.pigmentGreen : MountainlandColors.battleshipGray)
        }
        .buttonStyle(PlainButtonStyle())  // Removes default button styling
    }
}

// MARK: - Assignment Row Divider Component
/// Thin divider line between assignment rows
/// Uses platinum color for subtle separation
struct AssignmentRowDivider: View {
    // MARK: - Body
    var body: some View {
        Rectangle()
            .fill(MountainlandColors.platinum)
            .frame(height: 1)
            .padding(.leading, 78)  // Aligns with content indentation
    }
}

// MARK: - Preview with Sample Data
/// Xcode preview for design and layout testing
/// Shows the assignment list with sample student and course data
#Preview {
    AssignmentListView(
        currentUser: Student.demoStudents[0],
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
                    assignments: [
                        Assignment(assignmentID: "TP02", title: "List.Form", dueDate: Date(), lessonID: "02", assignmentType: .lab, markdownDescription: ""),
                        Assignment(assignmentID: "TP03", title: "Navigation", dueDate: Date(), lessonID: "02", assignmentType: .lab, markdownDescription: "")
                    ]
                )
            ]
        )
    )
}
