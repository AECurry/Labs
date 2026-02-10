//
//  AssignmentCheckoffView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

/// Assignment category selection screen
/// Displays assignment types (Labs & Projects, Code Challenges, etc.) for a course module
/// Navigates to individual assignment lists when tapped
struct AssignmentCheckoffView: View {
    let courseSection: CurriculumModule
    @Environment(AssignmentsViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            HStack {
                // Back button
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                // User Profile Circle (if you want it)
                // Add your profile circle here if needed
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
            
            // MARK: - Title
            Text(courseSection.title)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 24)
            
            // MARK: - Assignment Types Card
            VStack(spacing: 0) {
                ForEach(Array(courseSection.assignmentTypes.enumerated()), id: \.element.id) { index, assignmentType in
                    NavigationLink {
                        IndividualAssignmentsView(
                            courseSection: courseSection,
                            assignmentType: assignmentType
                        )
                        .environment(viewModel)
                    } label: {
                        AssignmentTypeSummaryRow(assignmentType: assignmentType)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Divider between items (not after last one)
                    if index < courseSection.assignmentTypes.count - 1 {
                        Divider()
                            .background(MountainlandColors.smokeyBlack.opacity(0.2))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(MountainlandColors.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .background(MountainlandColors.platinum.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - Assignment Type Summary Row
/// Clean row showing assignment category with chevron
struct AssignmentTypeSummaryRow: View {
    let assignmentType: AssignmentTypeSummary
    
    var body: some View {
        HStack(spacing: 12) {
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(MountainlandColors.smokeyBlack)
                .frame(width: 20)
            
            // Folder icon
            Image(systemName: "folder.fill")
                .foregroundColor(MountainlandColors.burgundy1.opacity(0.6))
            
            // Title with count
            Text("\(assignmentType.title)  (\(assignmentType.totalCount))")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(MountainlandColors.smokeyBlack)
            
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .contentShape(Rectangle())
    }
}

#Preview {
    AssignmentCheckoffView(
        courseSection: CurriculumModule(
            id: "02",
            title: "Tables & Persistence",
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
    .environment(AssignmentsViewModel())
}
