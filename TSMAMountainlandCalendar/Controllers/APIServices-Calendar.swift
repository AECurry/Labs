//
//  APIServices-Calendar.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/3/26
//

import Foundation

extension APIController {
    
    func fetchTodayContent() async throws -> CalendarEntryResponseDTO {
        let url = URL(string: "\(baseURL)/calendar/today")!
        let queryItems = [URLQueryItem(name: "cohort", value: cohort)]
        return try await makeRequest(url: url, method: "GET", queryItems: queryItems)
    }
    
    func fetchAllCalendarEntries() async throws -> [CalendarEntryResponseDTO] {
        let url = URL(string: "\(baseURL)/calendar/all")!
        let queryItems = [URLQueryItem(name: "cohort", value: cohort)]
        return try await makeRequest(url: url, method: "GET", queryItems: queryItems)
    }
   
    func fetchLessonOutline(lessonID: UUID) async throws -> LessonOutlineResponseDTO {
        let url = URL(string: "\(baseURL)/lesson/\(lessonID.uuidString.lowercased())")!
        return try await makeRequest(url: url, method: "GET")
    }
    
    func submitLessonFeedback(lessonID: UUID, feedback: String) async throws {
        let url = URL(string: "\(baseURL)/lesson/feedback")!
        
        guard let userSecret = self.userSecret else { throw APIError.notAuthenticated }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(userSecret.uuidString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: String] = ["lessonID": lessonID.uuidString, "feedback": feedback]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.networkError }
        guard httpResponse.statusCode == 200 else { throw APIError.serverError(httpResponse.statusCode) }
    }
}
