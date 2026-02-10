//
//  CurriculumModels.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import Foundation

// *Assignment Type Summary
/// Represents a category of assignments (Labs, Code Challenges, Vocab Quizzes, etc.)
/// Groups related assignments together and tracks completion progress
struct AssignmentTypeSummary: Identifiable {
    
    // *Core Properties
    let id: String                      // Unique identifier for this assignment type
    let title: String                   // Display name (e.g., "Labs & Projects")
    let completedCount: Int             // Number of completed assignments
    let totalCount: Int                 // Total number of assignments in this category
    let assignments: [Assignment]       // All assignments in this category
    
    // *Computed Properties
    /// Returns true if all assignments in this category are completed
    var isComplete: Bool {
        completedCount == totalCount && totalCount > 0
    }
    
    /// Returns completion percentage as a decimal (0.0 to 1.0)
    /// Useful for progress circle visualization
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(completedCount) / Double(totalCount)
    }
}

// *Curriculum Module
/// Represents a course module containing multiple assignment types
/// Organizes the curriculum into logical units with titles, date ranges, and assignments
struct CurriculumModule: Identifiable {
    
    // *Core Properties
    let id: String                              // Module identifier (e.g., "01")
    let title: String                           // Module title (e.g., "SwiftUI Basics")
    let dateRange: String                       // Module date range (e.g., "Oct 1 - Nov 15")
    let assignmentTypes: [AssignmentTypeSummary] // Assignment categories in this module
    
    // *Computed Properties
    /// Total assignments across all assignment types
    var totalAssignments: Int {
        assignmentTypes.reduce(0) { $0 + $1.totalCount }
    }
    
    /// Total completed assignments across all assignment types
    var completedAssignments: Int {
        assignmentTypes.reduce(0) { $0 + $1.completedCount }
    }
    
    /// Returns true if all assignments in this module are completed
    var isComplete: Bool {
        totalAssignments > 0 && completedAssignments == totalAssignments
    }
    
    /// Overall module completion percentage (0.0 to 1.0)
    var completionPercentage: Double {
        guard totalAssignments > 0 else { return 0.0 }
        return Double(completedAssignments) / Double(totalAssignments)
    }
}

// *Course Section (Legacy Support)
/// Legacy model for course section display
/// Maintains compatibility while transitioning to CurriculumModule
struct CourseSection: Identifiable {
    let id = UUID()
    let number: String      // Section number (e.g., "01")
    let title: String       // Section title
    let dateRange: String   // Section date range
    
    // *Conversion Method
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

// *Demo Data
/// Sample course sections for development and testing
/// Represents a typical iOS development curriculum structure
extension CourseSection {
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

// *Demo Curriculum Modules
/// Sample modules with assignment data for testing
/// Demonstrates structure with assignment type summaries
extension CurriculumModule {
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
