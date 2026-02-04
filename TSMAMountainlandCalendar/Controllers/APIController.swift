//
//  APIController.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 1/30/26.
//

import Foundation

// MARK: - Login Models (Keep these here since they're small)
struct LoginResponse: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let userUUID: UUID
    let secret: UUID  // This is the userSecret for API calls!
    let userName: String
}

enum LoginError: Error {
    case badResponse
    case systemError
}

// MARK: - Main API Controller
class APIController {
    // MARK: - Singleton Instance
    static let shared = APIController()
    
    // MARK: - Configuration Properties
    let baseURL = "https://social-media-app.ryanplitt.com"
    
    /// Store the userSecret (UUID) from login
    var userSecret: UUID?
    var cohort: String = "fall2025"
    
    // ADD THIS: Store the current logged-in student
    var currentUser: Student?
    
    // MARK: - Private Initializer
    private init() {}
    
    // MARK: - Login Method
    func login(email: String, password: String) async throws -> LoginResponse {
        let url = URL(string: "\(baseURL)/auth/login")!
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let queryString = components.percentEncodedQuery {
            request.httpBody = queryString.data(using: .utf8)
        }
        
        print("Login request to: \(url.absoluteString)")
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Server response: \(responseString)")
        }
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            print("Invalid server response")
            throw LoginError.systemError
        }
        
        print("Status code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            print("Server returned error status: \(httpResponse.statusCode)")
            throw LoginError.badResponse
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        do {
            let response = try jsonDecoder.decode(LoginResponse.self, from: data)
            
            // Store the userSecret
            self.userSecret = response.secret
            print("Login successful! UserSecret: \(response.secret)")
            print("User: \(response.firstName) \(response.lastName)")
            
            // ADD THIS: Find and store the matching student
            if let student = Student.demoStudents.first(where: { $0.email == email }) {
                self.currentUser = student
                print("Found matching student: \(student.name)")
            } else {
                print("Warning: No matching student found for email: \(email)")
            }
            
            saveSession()
            
            return response
        } catch {
            print("Failed to decode login response: \(error)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
            throw error
        }
    }
    
    // MARK: - Session Persistence
    private let userSecretKey = "savedUserSecret"
    private let cohortKey = "savedCohort"
    private let currentUserEmailKey = "savedCurrentUserEmail" // ADD THIS
    
    func saveSession() {
        if let userSecret = userSecret {
            UserDefaults.standard.set(userSecret.uuidString, forKey: userSecretKey)
        }
        UserDefaults.standard.set(cohort, forKey: cohortKey)
        
        // ADD THIS: Save the current user's email
        if let currentUser = currentUser {
            UserDefaults.standard.set(currentUser.email, forKey: currentUserEmailKey)
        }
        
        print("Session saved to UserDefaults")
    }
    
    func restoreSession() {
        // Restore userSecret and cohort
        if let savedSecret = UserDefaults.standard.string(forKey: userSecretKey),
           let uuid = UUID(uuidString: savedSecret) {
            userSecret = uuid
        }
        if let savedCohort = UserDefaults.standard.string(forKey: cohortKey) {
            cohort = savedCohort
        }
        
        // ADD THIS: Restore current user from email
        if let savedEmail = UserDefaults.standard.string(forKey: currentUserEmailKey),
           let student = Student.demoStudents.first(where: { $0.email == savedEmail }) {
            currentUser = student
            print("Restored current user: \(student.name)")
        }
        
        print("Session restored from UserDefaults")
    }
    
    func clearSession() {
        userSecret = nil
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userSecretKey)
        UserDefaults.standard.removeObject(forKey: cohortKey)
        UserDefaults.standard.removeObject(forKey: currentUserEmailKey)
        print("Session cleared")
    }
    
    // MARK: - Utility Methods
    func logout() {
        clearSession()
        print("User logged out")
    }
    
    var isAuthenticated: Bool {
        return userSecret != nil
    }
}
