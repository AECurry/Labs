//
//  AssignmentListView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Assignment List View
/// Displays a simple list of assignments loaded from the API
/// Organizes assignments by status with clear visual grouping
struct AssignmentListView: View {
    // MARK: - Properties
    let currentUser: Student
    let assignments: [Assignment]
    @State private var showingAssignmentOutline = false
    @State private var selectedAssignment: Assignment?
    
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
                AssignmentOutlineView(
                    assignment: assignment,
                    isCompleted: assignment.isCompleted,
                    onToggleComplete: {
                        // In a real app, this would update via ViewModel
                        // For now, we'll just dismiss
                    }
                )
            }
        }
    }
    
    // MARK: - Assignment Section
    private func AssignmentSection(title: String, assignments: [Assignment]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(MountainlandColors.smokeyBlack)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            ForEach(assignments) { assignment in
                AssignmentRowView(
                    assignment: assignment,
                    onToggleComplete: {
                        // This would need to be connected to a ViewModel
                        // For now, we'll leave it as a placeholder
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
    
    // MARK: - Computed Properties
    private var overdueAssignments: [Assignment] {
        assignments.filter { $0.isOverdue }
    }
    
    private var upcomingAssignments: [Assignment] {
        assignments.filter { !$0.isCompleted && !$0.isOverdue }
    }
    
    private var completedAssignments: [Assignment] {
        assignments.filter { $0.isCompleted }
    }
}
