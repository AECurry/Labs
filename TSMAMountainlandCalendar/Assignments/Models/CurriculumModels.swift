//
//  CurriculumModels.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import Foundation

// MARK: - Assignment Type Summary
/// Represents a category of assignments (Labs, Code Challenges, Vocab Quizzes, etc.)
/// Groups related assignments together and tracks completion progress
struct AssignmentTypeSummary: Identifiable {
    // MARK: - Core Properties
    let id: String                      // Unique identifier for this assignment type
    let title: String                   // Display name (e.g., "Labs & Projects")
    let completedCount: Int             // Number of completed assignments
    let totalCount: Int                 // Total number of assignments in this category
    let assignments: [Assignment]       // All assignments in this category
    
    // MARK: - Computed Properties
    /// Returns true if all assignments in this category are completed
    var isComplete: Bool {
        completedCount == totalCount && totalCount > 0
    }
    
    /// Calculates completion percentage as a decimal (0.0 to 1.0)
    /// Used for progress circle visualizations
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(completedCount) / Double(totalCount)
    }
}

// MARK: - Curriculum Module
/// Represents a course section or module containing multiple assignment types
/// Organizes the curriculum into logical units with date ranges
struct CurriculumModule: Identifiable {
    // MARK: - Core Properties
    let id: String                              // Module identifier (e.g., "01", "02", "03")
    let title: String                           // Module title (e.g., "SwiftUI Basics")
    let dateRange: String                       // When this module runs (e.g., "Oct 1 - Nov 15")
    let assignmentTypes: [AssignmentTypeSummary] // Categories of assignments in this module
    
    // MARK: - Computed Properties
    /// Returns the total number of assignments across all types in this module
    var totalAssignments: Int {
        assignmentTypes.reduce(0) { $0 + $1.totalCount }
    }
    
    /// Returns the total number of completed assignments across all types
    var completedAssignments: Int {
        assignmentTypes.reduce(0) { $0 + $1.completedCount }
    }
    
    /// Returns true if all assignments in this module are completed
    var isComplete: Bool {
        totalAssignments > 0 && completedAssignments == totalAssignments
    }
    
    /// Calculates overall module completion percentage (0.0 to 1.0)
    var completionPercentage: Double {
        guard totalAssignments > 0 else { return 0.0 }
        return Double(completedAssignments) / Double(totalAssignments)
    }
}

// MARK: - Course Section (Legacy Support)
/// Legacy model for course section display
/// Maintains compatibility with existing views while transitioning to CurriculumModule
struct CourseSection: Identifiable {
    let id = UUID()
    let number: String      // Section number (e.g., "01", "02")
    let title: String       // Section title
    let dateRange: String   // Date range for this section
    
    // MARK: - Conversion Method
    /// Converts CourseSection to CurriculumModule format
    /// Provides empty assignment types array for basic navigation
    func toCurriculumModule() -> CurriculumModule {
        return CurriculumModule(
            id: number,
            title: title,
            dateRange: dateRange,
            assignmentTypes: []
        )
    }
}

// MARK: - Demo Data
extension CourseSection {
    /// Sample course sections for development and testing
    /// Represents a typical iOS development curriculum structure
    static let demoData: [CourseSection] = [
        CourseSection(
            number: "01",
            title: "Introduction to Swift & Xcode",
            dateRange: "Aug 15 - Sep 15"
        ),
        CourseSection(
            number: "02",
            title: "SwiftUI Basics",
            dateRange: "Sep 16 - Oct 15"
        ),
        CourseSection(
            number: "03",
            title: "Tables & Persistence",
            dateRange: "Oct 16 - Nov 15"
        ),
        CourseSection(
            number: "04",
            title: "Networking & APIs",
            dateRange: "Nov 16 - Dec 15"
        ),
        CourseSection(
            number: "05",
            title: "Advanced SwiftUI",
            dateRange: "Jan 5 - Feb 5"
        ),
        CourseSection(
            number: "06",
            title: "Final Projects",
            dateRange: "Feb 6 - Mar 15"
        )
    ]
}

// MARK: - Demo Curriculum Modules
extension CurriculumModule {
    /// Sample curriculum modules with assignment data for testing
    /// Demonstrates the full data structure with assignments
    static let demoModules: [CurriculumModule] = [
        CurriculumModule(
            id: "01",
            title: "Introduction to Swift & Xcode",
            dateRange: "Aug 15 - Sep 15",
            assignmentTypes: [
                AssignmentTypeSummary(
                    id: "labs",
                    title: "Labs & Projects",
                    completedCount: 5,
                    totalCount: 8,
                    assignments: []
                ),
                AssignmentTypeSummary(
                    id: "challenges",
                    title: "Code Challenges",
                    completedCount: 15,
                    totalCount: 20,
                    assignments: []
                ),
                AssignmentTypeSummary(
                    id: "vocab",
                    title: "Vocab Quiz",
                    completedCount: 1,
                    totalCount: 1,
                    assignments: []
                )
            ]
        ),
        CurriculumModule(
            id: "02",
            title: "SwiftUI Basics",
            dateRange: "Sep 16 - Oct 15",
            assignmentTypes: [
                AssignmentTypeSummary(
                    id: "labs",
                    title: "Labs & Projects",
                    completedCount: 0,
                    totalCount: 12,
                    assignments: []
                ),
                AssignmentTypeSummary(
                    id: "challenges",
                    title: "Code Challenges",
                    completedCount: 0,
                    totalCount: 25,
                    assignments: []
                )
            ]
        ),
        CurriculumModule(
            id: "03",
            title: "Tables & Persistence",
            dateRange: "Oct 16 - Nov 15",
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
    ]
}
