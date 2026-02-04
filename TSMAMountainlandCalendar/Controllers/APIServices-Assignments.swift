//
//  APIServices-Assignments.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/3/26
//

import Foundation

// MARK: - Assignment API Services
/// Extension providing assignment-related API functionality to APIController
/// Handles assignment data retrieval, progress tracking, and FAQ management
/// Follows the Single Responsibility Principle by focusing exclusively on assignment operations
extension APIController {
    
    // MARK: - All Assignments
    /// Fetches all assignments for the current cohort from the API server
    /// Retrieves comprehensive assignment data including optional progress tracking and community FAQs
    /// - Parameters:
    ///   - includeProgress: Boolean flag to include user's personal progress state for each assignment (default: true)
    ///   - includeFAQs: Boolean flag to include community-generated FAQ entries for each assignment (default: true)
    /// - Returns: Array of AssignmentResponseDTO objects containing complete assignment information
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network/decoding errors
    /// - Note: This endpoint requires both user authentication and cohort identification
    func fetchAllAssignments(includeProgress: Bool = true, includeFAQs: Bool = true) async throws -> [AssignmentResponseDTO] {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for fetching all assignments
        let url = URL(string: "\(baseURL)/assignment/all")!
        
        // Prepare the request body with authentication, cohort, and data inclusion preferences
        let requestBody = AllAssignmentsRequest(
            userSecret: userSecret,
            cohort: cohort,
            includeProgress: includeProgress,
            includeFAQs: includeFAQs
        )
        
        // Execute the POST request and return the decoded response
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    // MARK: - Single Assignment
    /// Fetches detailed information for a specific assignment identified by its unique UUID
    /// Provides granular control over returned data through optional inclusion parameters
    /// - Parameters:
    ///   - assignmentID: Unique identifier of the assignment to retrieve details for
    ///   - includeProgress: Boolean flag to include user's personal progress state (default: true)
    ///   - includeFAQs: Boolean flag to include community-generated FAQ entries (default: true)
    /// - Returns: AssignmentResponseDTO object containing complete assignment details
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network/decoding errors
    /// - Note: The assignment ID can be obtained from calendar endpoints or the all-assignments endpoint
    func fetchAssignment(assignmentID: UUID, includeProgress: Bool = true, includeFAQs: Bool = true) async throws -> AssignmentResponseDTO {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for fetching a specific assignment
        let url = URL(string: "\(baseURL)/assignment/\(assignmentID.uuidString)")!
        
        // Prepare the request body with authentication and data inclusion preferences
        let requestBody = SingleAssignmentRequest(
            userSecret: userSecret,
            includeProgress: includeProgress,
            includeFAQs: includeFAQs
        )
        
        // Execute the POST request and return the decoded response
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    // MARK: - Submit Assignment Progress
    /// Updates the user's progress state for a specific assignment on the server
    /// Supports three progress states: "notStarted", "inProgress", and "complete"
    /// - Parameters:
    ///   - assignmentID: Unique identifier of the assignment to update progress for
    ///   - progress: New progress state string ("notStarted", "inProgress", or "complete")
    /// - Returns: AssignmentResponseDTO object with the updated progress state included
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network/decoding errors
    /// - Important: Progress strings must exactly match server expectations for successful updates
    func submitAssignmentProgress(assignmentID: UUID, progress: String) async throws -> AssignmentResponseDTO {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for submitting progress updates
        let url = URL(string: "\(baseURL)/assignment/progress")!
        
        // Prepare the request body with authentication, assignment ID, and new progress state
        let requestBody = AssignmentProgressRequest(
            userSecret: userSecret,
            assignmentID: assignmentID,
            progress: progress
        )
        
        // Execute the POST request and return the decoded response with updated progress
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    // MARK: - Delete Assignment Progress
    /// Completely clears the user's progress state for a specific assignment on the server
    /// Resets the assignment progress back to "notStarted" status
    /// - Parameter assignmentID: Unique identifier of the assignment to clear progress for
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network errors
    /// - Note: This operation is irreversible and removes all progress tracking for the assignment
    func deleteAssignmentProgress(assignmentID: UUID) async throws {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for deleting progress data
        let url = URL(string: "\(baseURL)/assignment/progress")!
        
        // Prepare the request body with authentication and assignment ID
        let requestBody = DeleteProgressRequest(
            userSecret: userSecret,
            assignmentID: assignmentID
        )
        
        // Execute the DELETE request (no return data expected)
        try await makeRequest(url: url, method: "DELETE", body: requestBody)
    }
    
    // MARK: - Submit FAQ
    /// Posts a new community FAQ entry for a specific assignment to the server
    /// Enables knowledge sharing by allowing users to contribute helpful questions and answers
    /// - Parameters:
    ///   - assignmentID: Unique identifier of the assignment this FAQ relates to
    ///   - question: The FAQ question text submitted by the user
    ///   - answer: The FAQ answer text submitted by the user
    /// - Throws: APIError.notAuthenticated if user is not logged in, or other network errors
    /// - Note: Submitted FAQs become visible to all users in the same cohort
    func submitFAQ(assignmentID: UUID, question: String, answer: String) async throws {
        // Verify user authentication before proceeding with API request
        guard let userSecret = userSecret else {
            throw APIError.notAuthenticated
        }
        
        // Construct the complete API endpoint URL for submitting FAQ entries
        let url = URL(string: "\(baseURL)/faq")!
        
        // Prepare the request body with authentication, assignment ID, and FAQ content
        let requestBody = FAQRequest(
            userSecret: userSecret,
            assignmentID: assignmentID,
            question: question,
            answer: answer
        )
        
        // Execute the POST request (no return data expected)
        try await makeRequest(url: url, method: "POST", body: requestBody)
    }
}
