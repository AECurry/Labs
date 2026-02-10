//
//  CourseSectionView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

/// Professional course section navigation screen
/// Displays curriculum modules organized by course topics
/// Integrates with API to show real assignment data and completion progress
struct CourseSectionView: View {
    let currentUser: Student
    @State private var viewModel = AssignmentsViewModel()
    @State private var curriculumModules: [CurriculumModule] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header
                headerView
                
                // MARK: - Title
                Text("Course Assignments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 40)
                
                // MARK: - Content
                contentView
            }
            .background(MountainlandColors.platinum.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .task {
            await loadData()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Spacer()
            
            // User Profile Circle
            ZStack {
                Circle()
                    .fill(MountainlandColors.burgundy2)
                    .frame(width: 40, height: 40)
                
                Text(currentUser.initials)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            ProgressView("Loading assignments...")
                .padding()
                .frame(maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else if curriculumModules.isEmpty {
            emptyStateView
        } else {
            moduleListView
        }
    }
    
    // MARK: - Module List
    private var moduleListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(curriculumModules) { module in
                    NavigationLink {
                        AssignmentCheckoffView(courseSection: module)
                            .environment(viewModel)
                    } label: {
                        CurriculumModuleCard(module: module)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Error View
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("Error Loading Assignments")
                .font(.headline)
                .foregroundColor(MountainlandColors.smokeyBlack)
            
            Text(error)
                .font(.body)
                .foregroundColor(MountainlandColors.battleshipGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button("Retry") {
                Task { await loadData() }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(MountainlandColors.burgundy1)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder")
                .font(.system(size: 48))
                .foregroundColor(MountainlandColors.battleshipGray)
                .padding(.bottom, 8)
            
            Text("No Assignments Available")
                .font(.headline)
                .foregroundColor(MountainlandColors.smokeyBlack)
            
            Text("Check back later for new assignments")
                .font(.body)
                .foregroundColor(MountainlandColors.battleshipGray)
        }
        .frame(maxHeight: .infinity)
    }
    
    // MARK: - Data Loading
    private func loadData() async {
        await viewModel.loadAssignments()
        curriculumModules = organizeIntoCurriculumModules(viewModel.assignments)
    }
    
    // MARK: - Curriculum Organization
    private func organizeIntoCurriculumModules(_ assignments: [Assignment]) -> [CurriculumModule] {
        guard !assignments.isEmpty else { return [] }
        
        // Define the 7 course sections from your curriculum
        let courseSections = [
            ("01", "Swift Fundamentals", "Aug 13 - Sept 31"),
            ("02", "Tables & Persistence", "Oct 1 - Nov 15"),
            ("03", "Networking & Data Storage", "Nov 15 - Dec 19"),
            ("04", "SwiftUI & Special Topic", "Jan 8 - Feb 19"),
            ("05", "Full App Development", "Feb 20 - March 15"),
            ("06", "Prototyping & Project Plan...", "April 16 - May 1"),
            ("07", "Group Capstone", "May 2 - May 20")
        ]
        
        var modules: [CurriculumModule] = []
        
        // For now, put all assignments in each section
        // Later we can filter by assignment ID patterns
        for (id, title, dateRange) in courseSections {
            let assignmentTypes = createAssignmentTypes(for: assignments)
            
            let module = CurriculumModule(
                id: id,
                title: title,
                dateRange: dateRange,
                assignmentTypes: assignmentTypes
            )
            
            modules.append(module)
        }
        
        return modules
    }
    
    private func createAssignmentTypes(for assignments: [Assignment]) -> [AssignmentTypeSummary] {
        let assignmentsByType = Dictionary(grouping: assignments) { $0.assignmentType }
        
        var types: [AssignmentTypeSummary] = []
        
        for (type, typeAssignments) in assignmentsByType {
            let completedCount = typeAssignments.filter { $0.isCompleted }.count
            let totalCount = typeAssignments.count
            
            let title: String
            switch type {
            case .lab, .project:
                title = "Labs & Projects"
            case .codeChallenge:
                title = "Code Challenges"
            case .vocabQuiz:
                title = "Vocab Quiz"
            case .reading:
                title = "Reading"
            }
            
            if let existingIndex = types.firstIndex(where: { $0.title == title }) {
                types[existingIndex] = AssignmentTypeSummary(
                    id: types[existingIndex].id,
                    title: title,
                    completedCount: types[existingIndex].completedCount + completedCount,
                    totalCount: types[existingIndex].totalCount + totalCount,
                    assignments: types[existingIndex].assignments + typeAssignments
                )
            } else {
                let typeSummary = AssignmentTypeSummary(
                    id: type.rawValue,
                    title: title,
                    completedCount: completedCount,
                    totalCount: totalCount,
                    assignments: typeAssignments
                )
                types.append(typeSummary)
            }
        }
        
        return types.sorted { $0.title < $1.title }
    }
}

// MARK: - Curriculum Module Card
/// Professional card displaying course module with progress tracking
struct CurriculumModuleCard: View {
    let module: CurriculumModule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(module.id)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundColor(MountainlandColors.burgundy1)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(MountainlandColors.smokeyBlack)
                        .multilineTextAlignment(.leading)
                    
                    Text(module.dateRange)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(MountainlandColors.battleshipGray)
                    
                    Text("\(module.completedAssignments)/\(module.totalAssignments) completed")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(MountainlandColors.battleshipGray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(MountainlandColors.battleshipGray)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(MountainlandColors.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    CourseSectionView(currentUser: Student.demoStudents[0])
}
