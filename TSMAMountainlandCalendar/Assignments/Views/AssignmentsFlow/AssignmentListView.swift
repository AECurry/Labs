//
//  AssignmentListView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI
import SwiftData

// MARK: - Assignment List View
/// Displays a simple list of assignments loaded from the API
/// Organizes assignments by status with clear visual grouping
/// Used as fallback view for displaying all assignments in flat list format
struct AssignmentListView: View {
    // MARK: - Properties
    /// Current user for personalized display
    let currentUser: Student
    
    /// Array of all assignments to display
    let assignments: [Assignment]
    
    /// Controls display of assignment detail sheet
    @State private var showingAssignmentOutline = false
    
    /// The assignment currently selected for detail view
    @State private var selectedAssignment: Assignment?
    
    /// SwiftData model context for local database operations
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Title Section
                /// Shows assignment overview title without extra navigation
                VStack(alignment: .leading, spacing: 4) {
                    Text("All Assignments")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(MountainlandColors.smokeyBlack)
                    
                    Text("Organized by status")
                        .font(.subheadline)
                        .foregroundColor(MountainlandColors.battleshipGray)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // MARK: - Assignments Card Container
                /// Container for all assignment sections
                VStack(spacing: 0) {
                    // Overdue Section
                    if !overdueAssignments.isEmpty {
                        AssignmentSection(title: "Overdue", assignments: overdueAssignments)
                    }
                    
                    // Upcoming Section
                    if !upcomingAssignments.isEmpty {
                        AssignmentSection(title: "Upcoming", assignments: upcomingAssignments)
                    }
                    
                    // Completed Section
                    if !completedAssignments.isEmpty {
                        AssignmentSection(title: "Completed", assignments: completedAssignments)
                    }
                    
                    // Empty State
                    if assignments.isEmpty {
                        emptyStateView
                    }
                }
                .background(MountainlandColors.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 24)
        }
        .background(MountainlandColors.platinum.ignoresSafeArea())
        .sheet(isPresented: $showingAssignmentOutline) {
            if let assignment = selectedAssignment {
                // ✅ FIXED: Added onToggleComplete parameter
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
    }
    
    // MARK: - Assignment Section
    /// Helper function that creates a titled section containing assignment rows
    /// Groups assignments by category (Overdue, Upcoming, Completed) for clear organization
    private func AssignmentSection(title: String, assignments: [Assignment]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section title
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(MountainlandColors.smokeyBlack)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            // Loop through assignments and create individual row cards
            ForEach(assignments) { assignment in
                AssignmentRowView(
                    assignment: assignment,
                    onToggleComplete: {
                        Task {
                            await toggleAssignmentCompletion(assignment)
                        }
                    },
                    onTap: {
                        selectedAssignment = assignment
                        showingAssignmentOutline = true
                    }
                )
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Empty State
    /// Displayed when no assignments are available
    /// Provides friendly message to user when assignment list is empty
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Text("No Assignments")
                .font(.headline)
                .foregroundColor(MountainlandColors.battleshipGray)
                .padding(.top, 24)
            Text("You don't have any assignments at this time.")
                .font(.body)
                .foregroundColor(MountainlandColors.battleshipGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
    }
    
    // MARK: - Completion Toggle with SwiftData
    /// Toggles assignment completion status in SwiftData and syncs with API
    /// Updates UI immediately for responsive user experience
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
    
    // MARK: - Computed Properties
    /// Filters assignments into overdue category
    /// Returns assignments past due date that are not completed
    private var overdueAssignments: [Assignment] {
        assignments.filter { $0.isOverdue }
    }
    
    /// Filters assignments into upcoming category
    /// Returns assignments not yet due and not completed
    private var upcomingAssignments: [Assignment] {
        assignments.filter { !$0.isCompleted && !$0.isOverdue }
    }
    
    /// Filters assignments into completed category
    /// Returns all assignments marked as complete
    private var completedAssignments: [Assignment] {
        assignments.filter { $0.isCompleted }
    }
}

// MARK: - Preview
/// Xcode preview showing assignment list with sample data
#Preview {
    AssignmentListView(
        currentUser: Student.demoStudents[0],
        assignments: [Assignment.placeholder]
    )
    .modelContainer(for: [Assignment.self], inMemory: true)
}
