//
//  AssignmentsViewModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import Foundation
import SwiftUI
import Observation

// MARK: - Curriculum Module
/// This file creates the "brain" behind the assignments screen.
/// It organizes assignments into course modules, tracks completion progress, handles navigation between screens, and lets students mark assignments as complete.
/// It's like a smart assignment tracker that knows where everything is and how much work you have left.
struct CurriculumModule: Identifiable, Hashable {
    // MARK: - Core Properties
    let id: String                      // Module identifier (e.g., "01", "02")
    let title: String                   // Module name (e.g., "Swift Fundamentals")
    let dateRange: String               // When this module runs (e.g., "Aug 13 - Sept 31")
    var assignmentTypes: [AssignmentTypeSummary] // Assignment categories in this module
    
    // MARK: - Helper Methods
    /// Finds a specific assignment category by its identifier
    /// Returns nil if no matching assignment type is found
    func assignmentType(withId id: String) -> AssignmentTypeSummary? {
        assignmentTypes.first { $0.id == id }
    }
}

// MARK: - Assignment Type Summary
/// Tracks progress for a category of assignments (e.g., Labs, Code Challenges)
/// Provides completion statistics and manages assignment collections
struct AssignmentTypeSummary: Identifiable, Hashable {
    // MARK: - Core Properties
    let id: String              // Category identifier (e.g., "labs", "challenges")
    let title: String           // Display name (e.g., "Labs & Projects")
    var completedCount: Int     // Number of completed assignments in this category
    let totalCount: Int         // Total number of assignments in this category
    var assignments: [Assignment] // Individual assignments in this category
    
    // MARK: - Computed Properties
    /// Calculates completion percentage for progress displays
    /// Returns 0 if there are no assignments in the category
    var completionPercentage: Double {
        totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0
    }
    
    /// Determines if all assignments in this category are complete
    var isComplete: Bool {
        completedCount == totalCount && totalCount > 0
    }
    
    // MARK: - Update Methods
    /// Recalculates completion count based on actual assignment completion status
    /// Ensures completion count stays synchronized with assignment data
    mutating func updateCompletionCount() {
        completedCount = assignments.filter { $0.isCompleted }.count
    }
}

// MARK: - Main Assignments ViewModel
/// Manages assignment data, navigation, and completion state across the app
/// Uses SwiftUI Observation for reactive state updates
@Observable
class AssignmentsViewModel {
    // MARK: - Published Properties
    var curriculumModules: [CurriculumModule] = []      // All course modules with assignments
    var selectedModule: CurriculumModule?               // Currently viewed module
    var selectedAssignmentType: AssignmentTypeSummary?  // Currently viewed assignment category
    var navigationPath = NavigationPath()               // Tracks navigation stack for deep linking
    
    // MARK: - Intent Methods
    /// Sets the currently selected module and updates navigation
    /// Triggers module detail view display
    func selectModule(_ module: CurriculumModule) {
        selectedModule = module
        navigationPath.append(module)
    }
    
    /// Sets the currently selected assignment category within a module
    /// Ensures reference to actual data rather than a copy for live updates
    func selectAssignmentType(_ assignmentType: AssignmentTypeSummary) {
        selectedAssignmentType = assignmentType
        if let module = selectedModule {
            // Create a binding to the actual assignment type in our data
            if let moduleIndex = curriculumModules.firstIndex(where: { $0.id == module.id }),
               let typeIndex = curriculumModules[moduleIndex].assignmentTypes.firstIndex(where: { $0.id == assignmentType.id }) {
                selectedAssignmentType = curriculumModules[moduleIndex].assignmentTypes[typeIndex]
            }
        }
        navigationPath.append(assignmentType)
    }
    
    /// Toggles completion status for an assignment and updates all related data
    /// Maintains data consistency across modules, types, and assignment lists
    func toggleAssignmentCompletion(_ assignment: Assignment) {
        // Find and update the assignment in our data structure
        for moduleIndex in curriculumModules.indices {
            for typeIndex in curriculumModules[moduleIndex].assignmentTypes.indices {
                if let assignmentIndex = curriculumModules[moduleIndex].assignmentTypes[typeIndex].assignments.firstIndex(where: { $0.id == assignment.id }) {
                    
                    // Toggle completion - set completion date or clear it
                    curriculumModules[moduleIndex].assignmentTypes[typeIndex].assignments[assignmentIndex].completionDate =
                        curriculumModules[moduleIndex].assignmentTypes[typeIndex].assignments[assignmentIndex].isCompleted ? nil : Date()
                    
                    // Update the completion count for this assignment type
                    curriculumModules[moduleIndex].assignmentTypes[typeIndex].updateCompletionCount()
                    
                    // Update selectedAssignmentType if it's currently selected
                    if selectedAssignmentType?.id == curriculumModules[moduleIndex].assignmentTypes[typeIndex].id {
                        selectedAssignmentType = curriculumModules[moduleIndex].assignmentTypes[typeIndex]
                    }
                    
                    return // Exit once found and updated
                }
            }
        }
    }
    
    // MARK: - Navigation Methods
    /// Returns to the main modules list by clearing navigation stack
    /// Resets all selection state
    func navigateBackToModules() {
        navigationPath.removeLast(navigationPath.count)
        selectedModule = nil
        selectedAssignmentType = nil
    }
    
    /// Returns to module detail view from assignment type view
    /// Preserves module selection while clearing assignment type selection
    func navigateBackToModuleDetail() {
        // Keep only the module in the path
        if let module = selectedModule {
            navigationPath = NavigationPath([module])
        }
        selectedAssignmentType = nil
    }
    
    // MARK: - Data Loading
    /// Loads sample curriculum data for development and testing
    /// In production, this would fetch from an API or database
    func loadPlaceholderData() {
        curriculumModules = PlaceholderData.curriculumModules
    }
}

// MARK: - Placeholder Data
/// Provides sample curriculum data for previews, testing, and development
/// Demonstrates the complete data structure with realistic assignment progress
struct PlaceholderData {
    /// Sample curriculum modules representing a typical iOS development course
    /// Includes multiple assignment categories with varying completion states
    static var curriculumModules: [CurriculumModule] {
        [
            CurriculumModule(
                id: "01",
                title: "Swift Fundamentals",
                dateRange: "Aug 13 - Sept 31",
                assignmentTypes: [
                    AssignmentTypeSummary(
                        id: "labs",
                        title: "Labs & Projects",
                        completedCount: 8,
                        totalCount: 12,
                        assignments: createPlaceholderAssignments(for: "01", type: .lab, count: 12, completed: 8)
                    ),
                    AssignmentTypeSummary(
                        id: "challenges",
                        title: "Code Challenges",
                        completedCount: 20,
                        totalCount: 25,
                        assignments: createPlaceholderAssignments(for: "01", type: .codeChallenge, count: 25, completed: 20)
                    ),
                    AssignmentTypeSummary(
                        id: "vocab",
                        title: "Vocab Quiz",
                        completedCount: 0,
                        totalCount: 1,
                        assignments: createPlaceholderAssignments(for: "01", type: .vocabQuiz, count: 1, completed: 0)
                    )
                ]
            ),
            CurriculumModule(
                id: "02",
                title: "Tables & Persistence",
                dateRange: "Oct 1 - Nov 15",
                assignmentTypes: [
                    AssignmentTypeSummary(
                        id: "labs",
                        title: "Labs & Projects",
                        completedCount: 0,
                        totalCount: 14,
                        assignments: [
                            Assignment(
                                assignmentID: "TP02",
                                title: "List.Form",
                                dueDate: Date().addingTimeInterval(86400),
                                lessonID: "02",
                                assignmentType: .lab,
                                markdownDescription: "# List.Form Lab\n\nPractice creating lists and forms in SwiftUI.",
                                completionDate: nil
                            ),
                            Assignment(
                                assignmentID: "TP03",
                                title: "Navigation",
                                dueDate: Date().addingTimeInterval(86400 * 2),
                                lessonID: "02",
                                assignmentType: .lab,
                                markdownDescription: "# Navigation Lab\n\nImplement navigation in SwiftUI.",
                                completionDate: nil
                            ),
                            Assignment(
                                assignmentID: "TP06",
                                title: "Meet My Family",
                                dueDate: Date().addingTimeInterval(86400 * 5),
                                lessonID: "02",
                                assignmentType: .project,
                                markdownDescription: "# Meet My Family Project\n\nCreate a family member app.",
                                completionDate: nil
                            )
                        ]
                    ),
                    AssignmentTypeSummary(
                        id: "challenges",
                        title: "Code Challenges",
                        completedCount: 28,
                        totalCount: 28,
                        assignments: createPlaceholderAssignments(for: "02", type: .codeChallenge, count: 28, completed: 28)
                    ),
                    AssignmentTypeSummary(
                        id: "vocab",
                        title: "Vocab Quiz",
                        completedCount: 0,
                        totalCount: 1,
                        assignments: createPlaceholderAssignments(for: "02", type: .vocabQuiz, count: 1, completed: 0)
                    )
                ]
            )
        ]
    }
    
    // MARK: - Helper Methods
    /// Generates sample assignments for development and testing
    /// Creates assignments with sequential due dates and specified completion status
    private static func createPlaceholderAssignments(for lessonID: String, type: Assignment.AssignmentType, count: Int, completed: Int) -> [Assignment] {
        var assignments: [Assignment] = []
        
        for i in 1...count {
            let isCompleted = i <= completed
            assignments.append(
                Assignment(
                    assignmentID: "\(type.rawValue.uppercased())\(i)",
                    title: "\(type.rawValue.capitalized) \(i)",
                    dueDate: Date().addingTimeInterval(86400 * Double(i)),
                    lessonID: lessonID,
                    assignmentType: type,
                    markdownDescription: "# \(type.rawValue.capitalized) \(i)\n\nDescription for \(type.rawValue) \(i).",
                    completionDate: isCompleted ? Date() : nil
                )
            )
        }
        
        return assignments
    }
}
