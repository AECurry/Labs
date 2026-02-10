//
//  APIModels.swift 
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/4/26
//

import Foundation

// MARK: - API Error
enum APIError: Error, LocalizedError {
    case notAuthenticated, networkError, serverError(Int), decodingError, unknown
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "Please log in"
        case .networkError: return "Network error"
        case .serverError(let code): return "Server error (code: \(code))"
        case .decodingError: return "Data format error"
        case .unknown: return "Unknown error"
        }
    }
}

// MARK: - Request Models (No userSecret in body)
struct CalendarRequest: Codable { let cohort: String }
struct AllAssignmentsRequest: Codable { let cohort: String; let includeProgress: Bool; let includeFAQs: Bool }
struct SingleAssignmentRequest: Codable { let includeProgress: Bool; let includeFAQs: Bool }
struct AssignmentProgressRequest: Codable { let assignmentID: UUID; let progress: String }
struct DeleteProgressRequest: Codable { let assignmentID: UUID }
struct FAQRequest: Codable { let assignmentID: UUID; let question: String; let answer: String }

// MARK: - Response DTOs
struct CalendarEntryResponseDTO: Codable, Identifiable {
    let id: UUID
    let date: Date
    let holiday: Bool
    let dayID: String?
    let lessonName: String?
    let lessonID: UUID?
    let mainObjective: String?
    let readingDue: String?
    let assignmentsDue: [AssignmentResponseDTO]
    let newAssignments: [AssignmentResponseDTO]
    let dailyCodeChallengeName: String?
    let wordOfTheDay: String?
}

struct AssignmentResponseDTO: Codable, Identifiable {
    let id: UUID
    let name: String
    let assignmentType: String
    let body: String?  // ✅ Optional - calendar endpoints don't include this
    let assignedOn: Date?  // ✅ Optional - not always sent
    let dueOn: Date?  // ✅ FIXED: Made optional - API isn't sending this!
    let userProgress: String?
    let faqs: [FAQResponseDTO]
}

struct FAQResponseDTO: Codable, Identifiable {
    let id: UUID
    let assignmentID: UUID
    let lessonID: UUID
    let question: String
    let answer: String
    let lastEditedOn: Date
    let lastEditedBy: String
}

struct LessonOutlineResponseDTO: Codable {
    let id: UUID
    let name: String
    let objectives: [String]
    let schedule: [ScheduleItem]
    let body: String
    let additionalResources: String
}

struct ScheduleItem: Codable {
    let id: UUID
    let startTime: TimeOfDay
    let endTime: TimeOfDay
    let task: String
}

struct TimeOfDay: Codable {
    let hour: Int
    let minute: Int
}
