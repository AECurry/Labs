//
//  APIServices-Assignments.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/3/26
//

import Foundation

extension APIController {
    
    func fetchAllAssignments(includeProgress: Bool = true, includeFAQs: Bool = true) async throws -> [AssignmentResponseDTO] {
        let url = URL(string: "\(baseURL)/assignment/all")!
        let queryItems = [
            URLQueryItem(name: "cohort", value: cohort),
            URLQueryItem(name: "includeProgress", value: String(includeProgress)),
            URLQueryItem(name: "includeFAQs", value: String(includeFAQs))
        ]
        return try await makeRequest(url: url, method: "GET", queryItems: queryItems)
    }
    
    func fetchAssignment(assignmentID: UUID, includeProgress: Bool = true, includeFAQs: Bool = true) async throws -> AssignmentResponseDTO {
        let url = URL(string: "\(baseURL)/assignment/\(assignmentID.uuidString)")!
        let queryItems = [
            URLQueryItem(name: "includeProgress", value: String(includeProgress)),
            URLQueryItem(name: "includeFAQs", value: String(includeFAQs))
        ]
        return try await makeRequest(url: url, method: "GET", queryItems: queryItems)
    }
    
    func submitAssignmentProgress(assignmentID: UUID, progress: String) async throws -> AssignmentResponseDTO {
        let url = URL(string: "\(baseURL)/assignment/progress")!
        let requestBody = AssignmentProgressRequest(assignmentID: assignmentID, progress: progress)
        return try await makeRequest(url: url, method: "POST", body: requestBody)
    }
    
    func deleteAssignmentProgress(assignmentID: UUID) async throws {
        let url = URL(string: "\(baseURL)/assignment/progress")!
        let requestBody = DeleteProgressRequest(assignmentID: assignmentID)
        try await makeRequest(url: url, method: "DELETE", body: requestBody)
    }
    
    func submitFAQ(assignmentID: UUID, question: String, answer: String) async throws {
        let url = URL(string: "\(baseURL)/faq")!
        let requestBody = FAQRequest(assignmentID: assignmentID, question: question, answer: answer)
        try await makeRequest(url: url, method: "POST", body: requestBody)
    }
}
