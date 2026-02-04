//
//  Assignment.swift
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
        
        /// Converts API assignment type strings to our internal enum values
        /// Ensures consistent type mapping between server and client
        static func from(apiType: String) -> AssignmentType {
            switch apiType.lowercased() {
            case "lab": return .lab
            case "project": return .project
            case "codechallenge", "challenge": return .codeChallenge
            case "quiz", "vocabquiz": return .vocabQuiz
            case "reading": return .reading
            default: return .lab // Default fallback for unknown types
            }
        }
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

// MARK: - API Integration
/// Local DTO definition since AssignmentResponseDTO is in a different module
/// This acts as a bridge between the API response and our internal model
private struct APIAssignmentDTO {
    let id: UUID
    let name: String
    let assignmentType: String
    let body: String
    let dueOn: Date
    let userProgress: String?
}

extension Assignment {
    /// Converts an API response DTO to our internal Assignment model
    /// Acts as a bridge between server data format and our app's data structure
    static func from(apiData: (id: UUID, name: String, assignmentType: String, body: String, dueOn: Date, userProgress: String?)) -> Assignment {
        return Assignment(
            assignmentID: apiData.id.uuidString,
            title: apiData.name,
            dueDate: apiData.dueOn,
            lessonID: apiData.id.uuidString, // Using assignment ID as fallback for lesson ID
            assignmentType: AssignmentType.from(apiType: apiData.assignmentType),
            markdownDescription: apiData.body,
            completionDate: apiData.userProgress == "complete" ? Date() : nil
        )
    }
    
    /// Converts an array of API response data to our internal Assignment models
    /// Enables bulk data conversion for efficient API integration
    static func from(apiDataArray: [(id: UUID, name: String, assignmentType: String, body: String, dueOn: Date, userProgress: String?)]) -> [Assignment] {
        return apiDataArray.map { from(apiData: $0) }
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

// MARK: - API Integration Extension
extension Assignment {
    init(from dto: AssignmentResponseDTO) {
        let completionDate: Date? = dto.userProgress == "complete" ? Date() : nil
        
        self.init(
            assignmentID: dto.id.uuidString,
            title: dto.name,
            dueDate: dto.dueOn,
            lessonID: dto.id.uuidString,
            assignmentType: AssignmentType.from(apiType: dto.assignmentType),
            markdownDescription: dto.body,
            completionDate: completionDate
        )
    }
    
    static func array(from dtos: [AssignmentResponseDTO]) -> [Assignment] {
        dtos.map { Assignment(from: $0) }
    }
}
