//
//  IndividualAssignmentsView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI
import SwiftData

// MARK: - Individual Assignments View
/// Professional individual assignments list with completion tracking
/// Displays assignments within a specific category with interactive checkboxes
/// Uses SwiftData for persistent local storage of completion status
/// FIXED: Uses .sheet(item:) instead of .sheet(isPresented:) to prevent blank screen bug
struct IndividualAssignmentsView: View {
    // MARK: - Properties
    /// The course module containing these assignments
    let courseSection: CurriculumModule
    
    /// The specific assignment category being displayed (Labs, Projects, etc.)
    let assignmentType: AssignmentTypeSummary
    
    /// SwiftData model context for local database operations
    @Environment(\.modelContext) private var modelContext
    
    /// Environment value for dismissing this view
    @Environment(\.dismiss) private var dismiss
    
    /// The assignment currently selected for detail view
    /// ✅ CRITICAL FIX: Using optional Assignment directly for .sheet(item:)
    /// SwiftUI will only present sheet when this becomes non-nil
    /// Automatically dismisses sheet when set back to nil
    @State private var selectedAssignment: Assignment?
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            /// Custom navigation header with back button
            HStack {
                // Back button returns to previous screen
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                .padding(.leading, 8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            // MARK: - Title
            /// Course section name displayed prominently
            Text(courseSection.title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 8)
            
            // MARK: - Assignment Type Indicator
            /// Shows which category of assignments is displayed
            HStack(spacing: 8) {
                Image(systemName: "chevron.down")
                    .font(.caption)
                Image(systemName: "folder.fill")
                    .foregroundColor(MountainlandColors.burgundy1.opacity(0.6))
                Text(assignmentType.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(MountainlandColors.smokeyBlack)
            }
            .padding(.bottom, 24)
            
            // MARK: - Assignments List
            /// Scrollable list of assignment rows with checkboxes
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(assignmentType.assignments.enumerated()), id: \.element.id) { index, assignment in
                        AssignmentCheckboxRow(
                            assignment: assignment,
                            onToggle: {
                                Task {
                                    await toggleAssignmentCompletion(assignment)
                                }
                            },
                            onTap: {
                                // ✅ CRITICAL FIX: Simply set the assignment
                                // SwiftUI will automatically present the sheet
                                // No boolean needed, no timing issues
                                selectedAssignment = assignment
                            }
                        )
                        
                        // Divider between assignments (not after last one)
                        if index < assignmentType.assignments.count - 1 {
                            Divider()
                                .padding(.leading, 70)
                        }
                    }
                }
                .background(MountainlandColors.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                .padding(.horizontal, 16)
            }
        }
        .background(MountainlandColors.platinum.ignoresSafeArea())
        .navigationBarHidden(true)
        
        // MARK: - Assignment Detail Sheet
        /// ✅ CRITICAL FIX: Using .sheet(item:) instead of .sheet(isPresented:)
        /// This prevents the blank screen bug by ensuring the assignment exists
        /// before SwiftUI attempts to render the sheet
        /// SwiftUI will only call this closure when selectedAssignment is non-nil
        .sheet(item: $selectedAssignment) { assignment in
            AssignmentOutlineView(
                assignment: assignment,
                isCompleted: assignment.isCompleted,
                onToggleComplete: {
                    Task {
                        await toggleAssignmentCompletion(assignment)
                    }
                }
            )
        }
    }
    
    // MARK: - Completion Toggle with SwiftData
    /// Toggles assignment completion status in SwiftData and syncs with API
    /// Updates UI immediately for responsive user experience
    /// Updates the assignment object directly which triggers SwiftUI refresh
    private func toggleAssignmentCompletion(_ assignment: Assignment) async {
        print("🔄 Toggling completion for: \(assignment.title)")
        
        // Toggle completion date (nil = not complete, Date = complete)
        assignment.completionDate = assignment.isCompleted ? nil : Date()
        
        // Save to SwiftData for local persistence
        do {
            try modelContext.save()
            print("✅ SwiftData save successful")
            
            // Sync with API (secondary, for multi-device consistency)
            if let assignmentUUID = UUID(uuidString: assignment.lessonID) {
                let progress = assignment.isCompleted ? "complete" : "notStarted"
                _ = try? await APIController.shared.submitAssignmentProgress(
                    assignmentID: assignmentUUID,
                    progress: progress
                )
                print("📡 API sync completed")
            }
        } catch {
            print("❌ Error saving to SwiftData: \(error)")
        }
    }
}

// MARK: - Assignment Checkbox Row
/// Individual assignment row with completion checkbox and details
/// Displays due date, assignment type, title, and interactive checkbox
/// Entire row is tappable to open assignment detail view
struct AssignmentCheckboxRow: View {
    // MARK: - Properties
    /// The assignment data to display
    let assignment: Assignment
    
    /// Closure called when checkbox is tapped
    let onToggle: () async -> Void
    
    /// Closure called when row is tapped (for detail view)
    let onTap: () -> Void
    
    // MARK: - Computed Properties
    /// Returns appropriate checkbox icon based on completion status
    private var completionIcon: String {
        assignment.isCompleted ? "checkmark.square.fill" : "square"
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            // MARK: - Due Date and Type Column
            /// Left column showing when assignment is due and its type
            VStack(alignment: .leading, spacing: 2) {
                Text("Due:")
                    .font(.caption2)
                    .foregroundColor(MountainlandColors.battleshipGray)
                
                Text(assignment.formattedDueDate)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(MountainlandColors.smokeyBlack)
                
                Text(assignment.assignmentType.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundColor(MountainlandColors.battleshipGray)
            }
            .frame(width: 90, alignment: .leading)
            
            // MARK: - Assignment Title
            /// Main assignment name with strikethrough when completed
            Text(assignment.title)
                .font(.body)
                .foregroundColor(MountainlandColors.smokeyBlack)
                .strikethrough(assignment.isCompleted)
            
            Spacer()
            
            // MARK: - Completion Checkbox
            /// Interactive checkbox for marking assignment complete/incomplete
            /// Prevents tap from propagating to row tap gesture
            Button(action: { Task { await onToggle() } }) {
                Image(systemName: completionIcon)
                    .font(.title3)
                    .foregroundColor(assignment.isCompleted ?
                        MountainlandColors.smokeyBlack : MountainlandColors.battleshipGray)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())  // Makes entire row tappable
        .onTapGesture(perform: onTap)  // Tap opens detail view
    }
}

// MARK: - Preview
/// Xcode preview showing individual assignments view with sample data
#Preview {
    IndividualAssignmentsView(
        courseSection: CurriculumModule(
            id: "02",
            title: "Tables & Persistence",
            dateRange: "Oct 1 - Nov 15",
            assignmentTypes: []
        ),
        assignmentType: AssignmentTypeSummary(
            id: "labs",
            title: "Labs & Projects",
            completedCount: 0,
            totalCount: 14,
            assignments: [Assignment.placeholder]
        )
    )
    .modelContainer(for: [Assignment.self], inMemory: true)
}
