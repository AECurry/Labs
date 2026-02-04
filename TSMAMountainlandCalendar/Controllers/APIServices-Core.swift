//
//  APIServices-Core.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/2/26.
//

import Foundation

// MARK: - Request Models

/// Codable request structure for calendar API endpoints requiring user authentication and cohort identification
/// Used for fetching calendar data such as today's lesson and the full academic calendar
struct CalendarRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
    let cohort: String        // Academic cohort identifier (e.g., "fall2025")
}

/// Codable request structure for lesson-related API endpoints requiring user authentication
/// Used for fetching lesson outlines and submitting lesson feedback
struct LessonRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
}

/// Codable request structure for fetching all assignments with optional progress and FAQ data
/// Provides flexibility to include or exclude user-specific progress tracking and community FAQs
struct AllAssignmentsRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
    let cohort: String        // Academic cohort identifier (e.g., "fall2025")
    let includeProgress: Bool // Whether to include user's progress tracking data for each assignment
    let includeFAQs: Bool     // Whether to include user-generated FAQ data for each assignment
}

/// Codable request structure for fetching a single assignment with optional metadata
/// Allows granular control over returned assignment data for detailed views
struct SingleAssignmentRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
    let includeProgress: Bool // Whether to include user's progress tracking data
    let includeFAQs: Bool     // Whether to include user-generated FAQ data
}

/// Codable request structure for updating assignment progress status
/// Supports three progress states: "notStarted", "inProgress", and "complete"
struct AssignmentProgressRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
    let assignmentID: UUID    // Unique identifier of the assignment to update progress for
    let progress: String      // New progress state ("notStarted", "inProgress", or "complete")
}

/// Codable request structure for deleting assignment progress data
/// Completely resets a user's progress on a specific assignment to "notStarted"
struct DeleteProgressRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
    let assignmentID: UUID    // Unique identifier of the assignment to clear progress for
}

/// Codable request structure for submitting new FAQ entries to assignments
/// Enables community knowledge sharing by allowing users to post helpful Q&A
struct FAQRequest: Codable {
    let userSecret: UUID      // User authentication secret obtained during login process
    let assignmentID: UUID    // Unique identifier of the assignment the FAQ relates to
    let question: String      // FAQ question text submitted by the user
    let answer: String        // FAQ answer text submitted by the user
}

// MARK: - Response Models (DTOs)

/// Data transfer object representing a single calendar day entry with full instructional details
/// Contains lesson information, assignments, and daily educational components
struct CalendarEntryResponseDTO: Codable, Identifiable {
    let id: UUID                          // Unique identifier for this calendar entry
    let date: Date                        // The instructional date this entry represents
    let holiday: Bool                     // Indicates if this day is a holiday/non-instructional day
    let dayID: String?                    // Optional day identifier (e.g., "Day 14")
    let lessonName: String?               // Optional display name of the day's lesson
    let lessonID: UUID?                   // Optional unique identifier for the associated lesson
    let mainObjective: String?            // Optional primary learning goal for the day
    let readingDue: String?               // Optional reading assignments due for this lesson
    let assignmentsDue: [AssignmentResponseDTO]   // Assignments that must be submitted today
    let newAssignments: [AssignmentResponseDTO]   // New assignments introduced today
    let dailyCodeChallengeName: String?   // Optional daily coding challenge title
    let wordOfTheDay: String?             // Optional vocabulary term for the day
}

/// Data transfer object representing a single assignment with all associated metadata
/// Contains assignment details, due dates, user progress, and community FAQs
struct AssignmentResponseDTO: Codable, Identifiable {
    let id: UUID                          // Unique identifier for this assignment
    let name: String                      // Display name of the assignment
    let assignmentType: String            // Type/category of assignment (e.g., "lab", "project")
    let body: String                      // Detailed assignment description/instructions
    let assignedOn: Date                  // Date when the assignment was assigned to students
    let dueOn: Date                       // Date when the assignment is due
    let userProgress: String?             // Optional user's progress state ("notStarted", "inProgress", "complete")
    let faqs: [FAQResponseDTO]            // Community-generated FAQ entries for this assignment
}

/// Data transfer object representing a user-generated FAQ entry for an assignment
/// Contains helpful questions and answers shared by the learning community
struct FAQResponseDTO: Codable, Identifiable {
    let id: UUID                          // Unique identifier for this FAQ entry
    let assignmentID: UUID                // Identifier of the assignment this FAQ relates to
    let lessonID: UUID                    // Identifier of the lesson this FAQ relates to
    let question: String                  // FAQ question text
    let answer: String                    // FAQ answer text
    let lastEditedOn: Date                // Timestamp of when this FAQ was last modified
    let lastEditedBy: String              // Username of the person who last edited this FAQ
}

/// Data transfer object representing a detailed lesson outline with structured content
/// Contains lesson objectives, schedule breakdown, and additional resources
struct LessonOutlineResponseDTO: Codable {
    let id: UUID                          // Unique identifier for this lesson outline
    let name: String                      // Display name of the lesson
    let objectives: [String]              // Learning objectives for the lesson
    let schedule: [ScheduleItem]          // Detailed time breakdown of lesson activities
    let body: String                      // Main lesson content in markdown/HTML format
    let additionalResources: String       // Supplementary resources and reference materials
}

/// Data transfer object representing a single time-block in a lesson schedule
/// Defines a specific activity with start/end times within a lesson
struct ScheduleItem: Codable {
    let id: UUID                          // Unique identifier for this schedule item
    let startTime: TimeOfDay              // Start time of this activity
    let endTime: TimeOfDay                // End time of this activity
    let task: String                      // Description of the activity/task
}

/// Data transfer object representing a specific time of day (hour and minute)
/// Used for scheduling lesson activities without date components
struct TimeOfDay: Codable {
    let hour: Int                         // Hour component (0-23)
    let minute: Int                       // Minute component (0-59)
}

// MARK: - API Error
/// Comprehensive error enumeration for API-related failures
/// Provides user-friendly error messages for different failure scenarios
enum APIError: Error, LocalizedError {
    case notAuthenticated     // User is not logged in or session has expired
    case networkError         // Network connectivity issues or timeout
    case serverError(Int)     // Server returned non-200 status code
    case decodingError        // Failed to parse server response
    case unknown              // Unexpected or unclassified error
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Please log in to access this feature"
        case .networkError:
            return "Network error. Please check your connection"
        case .serverError(let code):
            return "Server error (code: \(code))"
        case .decodingError:
            return "Data format error"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

// MARK: - Generic Request Methods
/// Extension providing reusable HTTP request functionality to APIController
/// Encapsulates common networking patterns for consistent API interactions
extension APIController {
    
    /// Generic method for making API requests that return decodable JSON data
    /// - Parameters:
    ///   - url: The complete URL endpoint for the API request
    ///   - method: HTTP method to use (GET, POST, PUT, DELETE, etc.)
    ///   - body: Optional Codable request body to send with the request
    /// - Returns: Decoded response of type T
    /// - Throws: APIError for network failures, server errors, or decoding issues
    func makeRequest<T: Decodable>(url: URL, method: String, body: Encodable? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
    
    /// Generic method for making API requests that don't return data (void responses)
    /// Used for operations like DELETE or POST that only return success/failure status
    /// - Parameters:
    ///   - url: The complete URL endpoint for the API request
    ///   - method: HTTP method to use (typically DELETE or POST)
    ///   - body: Optional Codable request body to send with the request
    /// - Throws: APIError for network failures or server errors
    func makeRequest(url: URL, method: String, body: Encodable? = nil) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
}
