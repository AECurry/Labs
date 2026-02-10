//
//  Assignment.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import Foundation
import SwiftData

// MARK: - FAQ Model
/// Represents frequently asked questions associated with assignments
/// Stores question, answer, and edit metadata for student reference
struct FAQ: Identifiable, Hashable, Codable {
    let id: UUID
    let assignmentID: UUID
    let lessonID: UUID
    let question: String
    let answer: String
    let lastEditedOn: Date
    let lastEditedBy: String
    
    /// Creates FAQ from API response DTO
    init(from dto: FAQResponseDTO) {
        self.id = dto.id
        self.assignmentID = dto.assignmentID
        self.lessonID = dto.lessonID
        self.question = dto.question
        self.answer = dto.answer
        self.lastEditedOn = dto.lastEditedOn
        self.lastEditedBy = dto.lastEditedBy
    }
}

// MARK: - Assignment Type Enum
/// Categorizes assignments by their type for organization and filtering
enum AssignmentType: String, CaseIterable, Codable {
    case lab, project, codeChallenge, vocabQuiz, reading
    
    /// Converts API assignment type string to enum case
    /// Handles various naming conventions from backend
    static func from(apiType: String) -> AssignmentType {
        switch apiType.lowercased() {
        case "lab": return .lab
        case "project": return .project
        case "codechallenge", "challenge": return .codeChallenge
        case "quiz", "vocabquiz": return .vocabQuiz
        case "reading": return .reading
        default: return .lab
        }
    }
}

// MARK: - Assignment Model (SwiftData)
/// A digital homework tracker that remembers assignment details, due dates, and completion status
/// Persisted locally using SwiftData for offline access and completion tracking
/// Syncs with API for multi-device consistency
@Model
class Assignment {
    // MARK: - Properties
    /// Unique identifier for this assignment instance
    @Attribute(.unique) var id: UUID
    
    /// Course-specific assignment identifier (e.g., "TP02", "SF25")
    /// Used for display and user recognition
    var assignmentID: String
    
    /// Human-readable assignment name
    var title: String
    
    /// Date when assignment is due
    /// Used for sorting, filtering, and overdue detection
    var dueDate: Date
    
    /// Identifier linking assignment to specific lesson/module
    var lessonID: String
    
    /// Category of assignment (lab, project, quiz, etc.)
    var assignmentType: AssignmentType
    
    /// Full assignment description in markdown format
    /// Displayed in detail view with rich text formatting
    var markdownDescription: String
    
    /// Date when assignment was initially assigned to student
    var assignedOn: Date?
    
    /// Collection of frequently asked questions for this assignment
    var faqs: [FAQ]
    
    /// Date when student marked assignment as complete
    /// Nil indicates assignment is not yet completed
    var completionDate: Date?
    
    // MARK: - Computed Properties
    /// Returns true if assignment has been marked complete
    var isCompleted: Bool {
        completionDate != nil
    }
    
    /// Returns true if assignment is past due and not completed
    /// Used for highlighting overdue assignments in red
    var isOverdue: Bool {
        !isCompleted && dueDate < Date()
    }
    
    /// Formats due date as user-friendly string (e.g., "Feb 12, 2026")
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: dueDate)
    }
    
    /// Formats assigned date as user-friendly string
    /// Falls back to due date if assignment date not available
    var formattedAssignedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: assignedOn ?? dueDate)
    }
    
    // MARK: - Initializers
    
    /// Primary initializer for creating assignments from scratch
    /// Used by SwiftData and manual assignment creation
    init(assignmentID: String, title: String, dueDate: Date, lessonID: String,
         assignmentType: AssignmentType, markdownDescription: String,
         completionDate: Date? = nil, assignedOn: Date? = nil, faqs: [FAQ] = []) {
        self.id = UUID()
        self.assignmentID = assignmentID
        self.title = title
        self.dueDate = dueDate
        self.lessonID = lessonID
        self.assignmentType = assignmentType
        self.markdownDescription = markdownDescription
        self.completionDate = completionDate
        self.assignedOn = assignedOn
        self.faqs = faqs
    }
    
    /// Convenience initializer for creating assignments from API DTOs
    /// Handles data transformation and intelligent defaults
    convenience init(from dto: AssignmentResponseDTO) {
        print("🔨 Creating Assignment from DTO:")
        print("   DTO ID: \(dto.id)")
        print("   DTO Name: '\(dto.name)'")
        print("   DTO Type: \(dto.assignmentType)")
        print("   DTO dueOn: \(dto.dueOn?.description ?? "NIL")")
        print("   DTO assignedOn: \(dto.assignedOn?.description ?? "NIL")")
        print("   DTO body preview: \(dto.body?.prefix(50) ?? "NIL")")
        
        // Determine completion status from API progress field
        let completionDate: Date? = dto.userProgress == "complete" ? Date() : nil
        
        // MARK: - Smart Title Extraction
        /// Attempts to extract meaningful title from various data sources
        /// Priority: dto.name → markdown headers → fallback to type-based name
        var displayTitle = dto.name
        
        // Handle empty or UUID-looking names (API sometimes returns UUIDs as names)
        if displayTitle.isEmpty || UUID(uuidString: displayTitle) != nil {
            // Try to extract title from markdown body
            if let body = dto.body, !body.isEmpty {
                let lines = body.components(separatedBy: .newlines)
                for line in lines {
                    let trimmed = line.trimmingCharacters(in: .whitespaces)
                    // Look for markdown headers (# or ##)
                    if trimmed.hasPrefix("# ") {
                        displayTitle = String(trimmed.dropFirst(2))
                        break
                    } else if trimmed.hasPrefix("## ") {
                        displayTitle = String(trimmed.dropFirst(3))
                        break
                    }
                }
            }
            
            // Still no good title? Generate from assignment type
            if displayTitle.isEmpty || UUID(uuidString: displayTitle) != nil {
                displayTitle = "Untitled \(dto.assignmentType.capitalized)"
            }
        }
        
        // MARK: - Extract Readable Course Identifier
        /// Searches for pattern like "TP02", "SF25" in title or body
        /// Falls back to "UNK-LAB" format if no pattern found
        var readableID = "UNK-\(dto.assignmentType.prefix(3).uppercased())"
        
        // Regex pattern to find course identifiers (2 letters + 2 numbers)
        let idPattern = /([A-Z]{2}\d{2})/
        if let match = displayTitle.firstMatch(of: idPattern) {
            readableID = String(match.1)
        } else if let body = dto.body, let match = body.firstMatch(of: idPattern) {
            readableID = String(match.1)
        }
        
        // MARK: - Smart Due Date Determination
        /// Uses API due date if available, falls back to 7 days after assignment
        /// Last resort: 7 days from current date
        let dueDate: Date
        if let apiDueDate = dto.dueOn {
            dueDate = apiDueDate
        } else if let assignedDate = dto.assignedOn {
            // Default to 1 week after assignment date
            dueDate = assignedDate.addingTimeInterval(86400 * 7)
        } else {
            // No dates provided - default to 1 week from now
            dueDate = Date().addingTimeInterval(86400 * 7)
        }
        
        // Call designated initializer with processed data
        self.init(
            assignmentID: readableID,
            title: displayTitle,
            dueDate: dueDate,
            lessonID: dto.id.uuidString,
            assignmentType: AssignmentType.from(apiType: dto.assignmentType),
            markdownDescription: dto.body ?? "No description available",
            completionDate: completionDate,
            assignedOn: dto.assignedOn,
            faqs: dto.faqs.map { FAQ(from: $0) }
        )
        
        print("   ✅ Created assignment: '\(self.title)' (ID: \(self.assignmentID))")
    }
}

// MARK: - Placeholder Data
/// Sample assignment for preview and testing purposes
extension Assignment {
    static let placeholder = Assignment(
        assignmentID: "LAB25",
        title: "Function Practice Lab",
        dueDate: Date(),
        lessonID: "SF25",
        assignmentType: .lab,
        markdownDescription: "# Function Practice Lab\n\nPractice writing functions in Swift.",
        completionDate: nil,
        assignedOn: Date().addingTimeInterval(-86400 * 2),
        faqs: []
    )
}

// MARK: - API Integration Extension
/// Bridges between API response format (DTO) and SwiftData model
extension Assignment {
    /// Batch conversion from API DTO array to Assignment array
    /// Used when loading all assignments from server
    static func array(from dtos: [AssignmentResponseDTO]) -> [Assignment] {
        dtos.map { Assignment(from: $0) }
    }
}
