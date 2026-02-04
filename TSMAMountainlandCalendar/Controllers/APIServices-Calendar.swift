//
//  APIServices-Calendar.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/3/26
//

import Foundation

// MARK: - Calendar API Services
/// Extension providing calendar and lesson-related API functionality to APIController
/// Handles calendar data retrieval, lesson outline fetching, and feedback submission
/// Follows the Single Responsibility Principle by focusing exclusively on calendar operations
extension APIController {
    
    // MARK: - Today's Calendar Entry
    /// Fetches today's instructional calendar entry including lessons, assignments, and daily components
    /// Retrieves comprehensive data for the current date including word of the day and code challenges
    /// - Returns: CalendarEntryResponseDTO object containing today's complete instructional content
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network/decoding errors
    /// - Note: Returns reduced data on holidays or days without scheduled instruction
    func fetchTodayContent() async throws -> CalendarEntryResponseDTO {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for fetching today's calendar entry
        let url = URL(string: "\(baseURL)/calendar/today")!
        
        // Prepare the request body with authentication and cohort identification
        let requestBody = CalendarRequest(userSecret: userSecret, cohort: cohort)
        
        // Execute the POST request and return the decoded response
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    // MARK: - All Calendar Entries
    /// Fetches the entire academic calendar for the current cohort from the server
    /// Retrieves a comprehensive timeline of instructional days, holidays, and scheduled content
    /// - Returns: Array of CalendarEntryResponseDTO objects representing the full academic term
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network/decoding errors
    /// - Note: Response includes basic data only; use individual calendar entry endpoints for full details
    func fetchAllCalendarEntries() async throws -> [CalendarEntryResponseDTO] {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for fetching the entire calendar
        let url = URL(string: "\(baseURL)/calendar/all")!
        
        // Prepare the request body with authentication and cohort identification
        let requestBody = CalendarRequest(userSecret: userSecret, cohort: cohort)
        
        // Execute the POST request and return the decoded response array
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    // MARK: - Lesson Outline
    /// Fetches detailed lesson outline for a specific lesson identified by its unique UUID
    /// Retrieves comprehensive instructional content including objectives, schedule, and resources
    /// - Parameter lessonID: Unique identifier of the lesson to retrieve outline for
    /// - Returns: LessonOutlineResponseDTO object containing complete lesson structure and content
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network/decoding errors
    /// - Note: Lesson IDs can be obtained from calendar endpoint responses
    func fetchLessonOutline(lessonID: UUID) async throws -> LessonOutlineResponseDTO {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for fetching lesson outline
        // Convert lesson ID to lowercase to match server expectations for URL formatting
        let url = URL(string: "\(baseURL)/lesson/\(lessonID.uuidString.lowercased())")!
        
        // Prepare the request body with authentication only (no cohort needed for lesson outlines)
        let requestBody = LessonRequest(userSecret: userSecret)
        
        // Execute the POST request and return the decoded response
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    // MARK: - Submit Lesson Feedback
    /// Submits user feedback for a specific lesson to the server for instructional improvement
    /// Enables students to provide constructive input on lesson content, delivery, and effectiveness
    /// - Parameters:
    ///   - lessonID: Unique identifier of the lesson to provide feedback for
    ///   - feedback: Textual feedback content submitted by the user
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network errors
    /// - Important: This endpoint uses a different request format requiring manual JSON serialization
    /// - Note: Feedback submissions are anonymous and used for continuous course improvement
    func submitLessonFeedback(lessonID: UUID, feedback: String) async throws {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for submitting lesson feedback
        let url = URL(string: "\(baseURL)/lesson/feedback")!
        
        // Prepare the request body as a dictionary since the generic makeRequest expects Encodable
        // This is necessary because the server expects a specific JSON structure for this endpoint
        let requestBody: [String: Any] = [
            "userSecret": userSecret.uuidString,
            "lessonID": lessonID.uuidString,
            "feedback": feedback
        ]
        
        // Manually create URLRequest since this endpoint requires dictionary-based JSON serialization
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Serialize the dictionary to JSON data for the request body
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Execute the request and capture the response
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Verify the response is a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        // Verify the server returned a successful status code (200 OK)
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        // No return data expected - success is indicated by 200 status code
    }
}
