//
//  CourseSectionModel.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import Foundation

// MARK: - Course Section Model
/// This file defines what a "course section" is - with its timeline and status
/// Tracks each segment of the curriculum throughout the academic period
struct CourseSection: Identifiable, Hashable {
    // MARK: - Core Properties
    let id = UUID()            // Unique identifier for SwiftUI lists
    let number: String         // Section number (e.g., "01", "02")
    let title: String          // Section title (e.g., "Swift Fundamentals")
    let dateRange: String      // When this section runs (e.g., "Aug 13 - Sept 31")
    let isActive: Bool         // Whether this is the current active section
    
    // MARK: - Demo Data
    /// Sample course sections for previews, testing, and development
    /// Represents a full iOS development curriculum from basics to capstone
    static let demoData: [CourseSection] = [
        CourseSection(number: "01", title: "Swift Fundamentals", dateRange: "Aug 13 - Sept 31", isActive: false),
        CourseSection(number: "02", title: "Tables & Persistence", dateRange: "Oct 1 - Nov 15", isActive: true),
        CourseSection(number: "03", title: "Networking & Data Storage", dateRange: "Nov 15 - Dec 19", isActive: false),
        CourseSection(number: "04", title: "SwiftUI & Special Topic", dateRange: "Jan 8 - Feb 19", isActive: false),
        CourseSection(number: "05", title: "Full App Development", dateRange: "Feb 20 - March 15", isActive: false),
        CourseSection(number: "06", title: "Prototyping & Project Planning", dateRange: "April 16 - May 1", isActive: false),
        CourseSection(number: "07", title: "Group Capstone", dateRange: "May 2 - May 20", isActive: false)
    ]
    
    // MARK: - Conversion Method
    /// Transforms this course section into a curriculum module with assignments
    /// Used for displaying detailed section content in the curriculum view
    func toCurriculumModule() -> CurriculumModule {
        CurriculumModule(
            id: number,
            title: title,
            dateRange: dateRange,
            assignmentTypes: generateAssignmentTypes()
        )
    }
    
    // MARK: - Private Helper Methods
    /// Creates sample assignment categories with placeholder data
    /// In production, this would fetch real assignment data from an API
    private func generateAssignmentTypes() -> [AssignmentTypeSummary] {
        // This is placeholder data - you'll want to replace this with real data
        return [
            AssignmentTypeSummary(
                id: "labs",
                title: "Labs & Projects",
                completedCount: 0,
                totalCount: 14,
                assignments: generateSampleAssignments()
            ),
            AssignmentTypeSummary(
                id: "challenges",
                title: "Code Challenges",
                completedCount: 0,
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
    }
    
    /// Generates sample assignments for development and testing
    /// Creates basic assignment objects with section-specific identifiers
    private func generateSampleAssignments() -> [Assignment] {
        // Placeholder assignments - replace with real data
        return [
            Assignment(assignmentID: "\(number)01", title: "List.Form", dueDate: Date(), lessonID: number, assignmentType: .lab, markdownDescription: ""),
            Assignment(assignmentID: "\(number)02", title: "Navigation", dueDate: Date(), lessonID: number, assignmentType: .lab, markdownDescription: ""),
            Assignment(assignmentID: "\(number)03", title: "Meet My Family", dueDate: Date(), lessonID: number, assignmentType: .project, markdownDescription: "")
        ]
    }
}
