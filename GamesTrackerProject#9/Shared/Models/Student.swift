//
//  Student.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData
import Foundation

// MARK: - Student Model
@Model
final class Student {
    @Attribute(.unique) var id: UUID
    var name: String
    var grade: Int
    var skillLevel: SkillLevel
    var studentID: String
    var email: String?
    var phoneNumber: String?
    var isActive: Bool
    var dateCreated: Date
    var lastPlayed: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        grade: Int = 9,
        skillLevel: SkillLevel = .intermediate,
        studentID: String = "",
        email: String? = nil,
        phoneNumber: String? = nil,
        isActive: Bool = true,
        dateCreated: Date = Date(),
        lastPlayed: Date? = nil
    ) {
        self.id = id
        self.name = name.trimmed()
        self.grade = grade
        self.skillLevel = skillLevel
        self.studentID = studentID.trimmed()
        self.email = email?.trimmed()
        self.phoneNumber = phoneNumber?.trimmed()
        self.isActive = isActive
        self.dateCreated = dateCreated
        self.lastPlayed = lastPlayed
    }
}

// MARK: - Name Components Extension
extension Student {
    /// First name extracted from full name
    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }
    
    /// Last name extracted from full name
    var lastName: String {
        let components = name.components(separatedBy: " ")
        guard components.count > 1 else { return "" }
        return components.dropFirst().joined(separator: " ")
    }
    
    /// First initial for avatar display
    var initial: String {
        let firstChar = firstName.prefix(1)
        return firstChar.isEmpty ? "?" : String(firstChar.uppercased())
    }
    
    /// Display-friendly full name
    var displayName: String {
        name.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    /// Formatted grade display
    var gradeDisplay: String {
        "Grade \(grade)"
    }
    
    /// Validation check
    var hasValidName: Bool {
        !displayName.trimmed().isEmpty && displayName.count > 1
    }
    
    var hasFullName: Bool {
        !lastName.isEmpty
    }
    
    /// Games count for display
    var gamesCount: Int {
        // If you have a games relationship, use: games?.count ?? 0
        // For now, return 0 as placeholder
        return 0
    }
    
    /// Check if student has played recently (within 30 days)
    var hasPlayedRecently: Bool {
        guard let lastPlayed = lastPlayed else { return false }
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        return lastPlayed > thirtyDaysAgo
    }
    
    /// Formatted last played date
    var lastPlayedFormatted: String {
        guard let lastPlayed = lastPlayed else { return "Never" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: lastPlayed, relativeTo: Date())
    }
}

// MARK: - Skill Level Enum
enum SkillLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case pro = "Pro"
    
    var color: Color {
        switch self {
        case .beginner: return .fnGreen
        case .intermediate: return .fnBlue
        case .advanced: return .fnPurple
        case .pro: return .fnGold
        }
    }
    
    var icon: String {
        switch self {
        case .beginner: return "1.circle.fill"
        case .intermediate: return "2.circle.fill"
        case .advanced: return "3.circle.fill"
        case .pro: return "4.circle.fill"
        }
    }
}

// MARK: - Sample Data for Previews
extension Student {
    static let sampleStudents: [Student] = [
        Student(name: "Alex Martinez", grade: 11, skillLevel: .pro, studentID: "AM001"),
        Student(name: "Jordan Lee", grade: 10, skillLevel: .advanced, studentID: "JL002"),
        Student(name: "Taylor Smith", grade: 12, skillLevel: .advanced, studentID: "TS003"),
        Student(name: "Casey Johnson", grade: 11, skillLevel: .intermediate, studentID: "CJ004"),
        Student(name: "Morgan Davis", grade: 9, skillLevel: .intermediate, studentID: "MD005"),
        Student(name: "Riley Chen", grade: 10, skillLevel: .beginner, studentID: "RC006"),
        Student(name: "Avery Brown", grade: 12, skillLevel: .pro, studentID: "AB007"),
        Student(name: "Quinn Wilson", grade: 11, skillLevel: .advanced, studentID: "QW008"),
    ]
    
    /// Seeds preview data into the provided ModelContext
    static func seedPreviewData(into context: ModelContext) {
        // Check if data already exists to avoid duplicates
        let descriptor = FetchDescriptor<Student>()
        if let existingCount = try? context.fetchCount(descriptor), existingCount > 0 {
            return
        }
        
        // Insert sample students into context
        for student in sampleStudents {
            context.insert(student)
        }
        
        // Persist the data
        try? context.save()
    }
}

// MARK: - String Extension
private extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
