//
//  Assingment.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation

// MARK: - Assignment Model
/// A digital homework tracker that remembers assignment details, due dates, and your completion status, like a smart digital planner.
/// Identifiable gives each assignment a unique name tag for display, while Hashable lets the computer quickly find and organize them like a smart filing system.
struct Assignment: Identifiable, Hashable {
    // MARK: - Core Properties
    let id = UUID()                    // Unique identifier for SwiftUI lists
    let assignmentID: String           // Course-specific assignment identifier (e.g., "LAB25")
    let title: String                  // Display title of the assignment
    let dueDate: Date                  // When the assignment is due
    
    // MARK: - Assignment Metadata
    let lessonID: String               // Associated lesson identifier
    let assignmentType: AssignmentType // Categorized type for filtering and display
    let markdownDescription: String    // Assignment details in markdown format
    var completionDate: Date?          // When assignment was completed (nil if incomplete)
    
    // MARK: - Assignment Type Enum
    /// Categorizes assignments for type-safe filtering and organized display
    /// Follows SOLID principles by encapsulating assignment categories
    enum AssignmentType: String, CaseIterable {
        case lab, project, codeChallenge, vocabQuiz, reading
    }
    
    // MARK: - Computed Properties
    /// Determines if assignment has been completed
    /// Returns true when completionDate contains a value
    var isCompleted: Bool {
        completionDate != nil
    }
    
    /// Determines if assignment is past due and not completed
    /// Returns true when due date has passed and assignment is incomplete
    var isOverdue: Bool {
        !isCompleted && dueDate < Date()
    }
    
    /// Formats due date for user-friendly display
    /// Uses medium date style (e.g., "Nov 13, 2025")
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }
}

// MARK: - Placeholder Data
extension Assignment {
    /// Sample assignment for previews, testing, and development
    /// Provides consistent mock data across the application
    static let placeholder = Assignment(
        assignmentID: "LAB25",
        title: "Function Practice Lab",
        dueDate: Date(),
        lessonID: "SF25",
        assignmentType: .lab,
        markdownDescription: "# Function Practice Lab\n\nPractice writing functions in Swift.",
        completionDate: nil
    )
}
