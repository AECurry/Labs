//
//  APIControllerImplementation.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 1/29/26.
//

// MARK: - API Controller Implementation Extension
/// This file contains the implementation of calendar and feedback methods.
/// Separated from main file to keep each file under 300 lines while maintaining clean organization.
/// All properties are accessible because they use default internal access level.

import Foundation

// MARK: - Extension: Calendar Data Methods
/// These methods handle fetching lesson plans and assignments from the server.
/// They're the workhorses that power the Today and Calendar tabs.
extension APIController {
    // MARK: - Calendar Data
    /// Fetches the lesson plan for a specific date.
    /// This is how the Today tab gets its content!
    /// - Parameter date: The date we want the lesson for (e.g., today's date)
    /// - Returns: CalendarEntry with all lesson details, or nil if no lesson that day
    /// - Throws: APIError if the server can't provide the data
    func fetchDailyContent(for date: Date) async throws -> CalendarEntry? {
        // Use mock data if in development mode
        if useMockData {
            return try await mockFetchDailyContent(for: date)
        }
        
        // Build URL for daily lesson endpoint
        let endpoint = "/api/calendar/daily"
        let urlString = baseURL + endpoint // ✅ ACCESSIBLE! baseURL is internal
        
        var urlComponents = URLComponents(string: urlString)
        
        // Convert Swift Date to string format the server understands (ISO8601)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let dateString = dateFormatter.string(from: date)
        
        // Add the date as a query parameter: /api/calendar/daily?date=2025-01-29T12:00:00Z
        urlComponents?.queryItems = [
            URLQueryItem(name: "date", value: dateString)
        ]
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        // Prepare GET request (we're asking for data, not sending)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")  // We want JSON back
        
        // Add our authentication token if we have one (proves we're logged in)
        // ✅ ACCESSIBLE! authToken is internal
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            // Send request and get response
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Check for successful response
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorized  // Token expired or invalid
                }
                throw APIError.statusCode(httpResponse.statusCode)
            }
            
            // Decode the JSON response
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601  // Tell decoder about ISO date format
            
            let apiDay = try decoder.decode(CalendarAPIDay.self, from: data)
            // Convert server format to our app's format
            return try convertAPIDayToCalendarEntry(apiDay)
        } catch {
            throw APIError.networkError(error)  // Internet problem (no connection, timeout)
        }
    }
    
    /// Fetches ALL calendar entries for a date range (usually the whole school year).
    /// This powers the monthly calendar view so it can show which days have lessons.
    /// - Returns: Array of CalendarEntry objects for the academic year
    /// - Throws: APIError if the server can't provide the data
    func fetchAllEntries() async throws -> [CalendarEntry] {
        // Use mock data if in development mode
        if useMockData {
            return try await mockFetchAllEntries()
        }
        
        // Build URL for calendar range endpoint
        let endpoint = "/api/calendar/range"
        let urlString = baseURL + endpoint // ✅ ACCESSIBLE!
        
        var urlComponents = URLComponents(string: urlString)
        
        // Calculate dates for the current academic year (August to June)
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2025, month: 8, day: 1)) ?? Date()
        let endDate = calendar.date(from: DateComponents(year: 2026, month: 6, day: 30)) ?? Date()
        
        // Format dates to ISO strings for the server
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let startString = dateFormatter.string(from: startDate)
        let endString = dateFormatter.string(from: endDate)
        
        // Add date range as query parameters
        urlComponents?.queryItems = [
            URLQueryItem(name: "start", value: startString),
            URLQueryItem(name: "end", value: endString)
        ]
        
        guard let url = urlComponents?.url else {
            throw APIError.invalidURL
        }
        
        // Prepare GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add authentication if logged in
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorized
                }
                throw APIError.statusCode(httpResponse.statusCode)
            }
            
            // Decode the response
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let apiResponse = try decoder.decode(CalendarAPIResponse.self, from: data)
            // Convert each server day to our app's format
            return try apiResponse.calendarEntries.map { try convertAPIDayToCalendarEntry($0) }
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Feedback Submission
    /// Sends student feedback about a lesson to the teacher.
    /// This is what happens when you tap "Submit Feedback" in the Today tab.
    /// - Parameters:
    ///   - lessonID: Which lesson the feedback is about (e.g., "TT14")
    ///   - whatWentWell: What the student liked or understood
    ///   - stillConfused: What needs more explanation
    ///   - suggestions: Ideas for improving the lesson
    /// - Throws: APIError if the feedback can't be delivered
    func submitFeedback(lessonID: String, whatWentWell: String, stillConfused: String, suggestions: String) async throws {
        // Use mock submission if in development mode
        if useMockData {
            return try await mockSubmitFeedback(lessonID: lessonID, whatWentWell: whatWentWell, stillConfused: stillConfused, suggestions: suggestions)
        }
        
        // Build URL for feedback endpoint
        let endpoint = "/api/feedback"
        let urlString = baseURL + endpoint // ✅ ACCESSIBLE!
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        // Create feedback data with timestamp
        let feedbackData: [String: Any] = [
            "lessonID": lessonID,
            "whatWentWell": whatWentWell,
            "stillConfused": stillConfused,
            "suggestions": suggestions,
            "timestamp": ISO8601DateFormatter().string(from: Date())  // When feedback was given
        ]
        
        // Convert to JSON
        let jsonData = try JSONSerialization.data(withJSONObject: feedbackData)
        
        // Prepare POST request (we're sending data to the server)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication if logged in
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = jsonData  // Attach our feedback
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Check if submission was successful
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorized
                }
                throw APIError.statusCode(httpResponse.statusCode)
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Helper Methods (Data Conversion)
    
    /// Converts server's CalendarAPIDay format to our app's CalendarEntry format.
    /// This is like translating between two languages - server-speak to app-speak.
    private func convertAPIDayToCalendarEntry(_ apiDay: CalendarAPIDay) throws -> CalendarEntry {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Convert ISO date string to Swift Date object
        guard let date = dateFormatter.date(from: apiDay.date) else {
            throw APIError.decodingError("Invalid date format: \(apiDay.date)")
        }
        
        // Convert server assignments to our app's Assignment objects
        let assignmentsDue = try apiDay.assignmentsDue.map { try convertAPIAssignment($0) }
        let newAssignments = try apiDay.newAssignments.map { try convertAPIAssignment($0) }
        
        // Create our app's CalendarEntry with all the data
        return CalendarEntry(
            date: date,
            lessonID: apiDay.lessonID,
            lessonName: apiDay.lessonName,
            mainObjective: apiDay.mainObjective,
            readingDue: apiDay.readingDue,
            assignmentsDue: assignmentsDue,
            newAssignments: newAssignments,
            codeChallenge: apiDay.codeChallenge,
            wordOfTheDay: apiDay.wordOfTheDay,
            instructor: apiDay.instructor,
            lessonOutline: apiDay.lessonOutline
        )
    }
    
    /// Converts server's APIAssignment format to our app's Assignment format.
    /// Handles date conversion and enum translation for assignment types.
    private func convertAPIAssignment(_ apiAssignment: APIAssignment) throws -> Assignment {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Convert due date string to Date
        guard let dueDate = dateFormatter.date(from: apiAssignment.dueDate) else {
            throw APIError.decodingError("Invalid due date format: \(apiAssignment.dueDate)")
        }
        
        // Convert server's string assignment type to our app's enum
        let assignmentType: Assignment.AssignmentType
        switch apiAssignment.assignmentType.lowercased() {
        case "lab":
            assignmentType = .lab
        case "project":
            assignmentType = .project
        case "codechallenge", "challenge":
            assignmentType = .codeChallenge
        case "vocabquiz", "quiz":
            assignmentType = .vocabQuiz
        case "reading":
            assignmentType = .reading
        default:
            assignmentType = .lab  // Safe default if server sends something unexpected
        }
        
        // Convert completion date if it exists
        var completionDate: Date? = nil
        if let completionDateString = apiAssignment.completionDate {
            completionDate = dateFormatter.date(from: completionDateString)
        }
        
        // Create our app's Assignment object
        return Assignment(
            assignmentID: apiAssignment.assignmentID,
            title: apiAssignment.title,
            dueDate: dueDate,
            lessonID: apiAssignment.lessonID,
            assignmentType: assignmentType,
            markdownDescription: apiAssignment.markdownDescription,
            completionDate: completionDate
        )
    }
    
    // MARK: - Mock Implementations (Development Helpers)
    
    /// Fake daily content fetch using your existing placeholder data.
    /// Finds the placeholder entry that matches the requested date.
    private func mockFetchDailyContent(for date: Date) async throws -> CalendarEntry? {
        try await Task.sleep(nanoseconds: 300_000_000) // Quarter-second delay
        
        // Search your placeholder data for matching date
        let placeholders = CalendarEntry.placeholders
        return placeholders.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    /// Fake "all entries" fetch using your placeholder data.
    private func mockFetchAllEntries() async throws -> [CalendarEntry] {
        try await Task.sleep(nanoseconds: 500_000_000) // Half-second delay
        
        // Return all your placeholder data
        return CalendarEntry.placeholders
    }
    
    /// Fake feedback submission - just prints to console for testing.
    private func mockSubmitFeedback(lessonID: String, whatWentWell: String, stillConfused: String, suggestions: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000) // Quarter-second delay
        
        // Print to console instead of sending to server
        print("Mock feedback submitted:")
        print("  Lesson: \(lessonID)")
        print("  What went well: \(whatWentWell)")
        print("  Still confused: \(stillConfused)")
        print("  Suggestions: \(suggestions)")
        
        // Simulate successful submission
        return
    }
}

// MARK: - Extension: Convenience API (Optional)
/// Extra helper methods for simpler use cases.
/// These are optional but can make some code cleaner.
extension APIController {
    /// Quick login with completion handler instead of async/await.
    /// Useful for older code or simple closures.
    static func quickLogin(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        Task {
            do {
                let response = try await shared.login(email: email, password: password)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Quick daily content fetch with completion handler.
    /// Defaults to today's date if no date provided.
    static func quickDailyContent(for date: Date = Date(), completion: @escaping (Result<CalendarEntry?, Error>) -> Void) {
        Task {
            do {
                let content = try await shared.fetchDailyContent(for: date)
                completion(.success(content))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
