//
//  APIController.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 1/30/26.
//

import Foundation

// MARK: - Login Models
struct LoginResponse: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let userUUID: UUID
    let secret: UUID
    let userName: String
}

enum LoginError: Error {
    case badResponse
    case systemError
}

class APIController {
    static let shared = APIController()
    
    let baseURL = "https://social-media-app.ryanplitt.com"
    var userSecret: UUID?
    var cohort: String = "fall2025"
    var currentUser: Student?
    
    private init() {}
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let url = URL(string: "\(baseURL)/auth/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let requestBody = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw LoginError.systemError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw LoginError.badResponse
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let response = try jsonDecoder.decode(LoginResponse.self, from: data)
        self.userSecret = response.secret
        
        if let student = Student.demoStudents.first(where: { $0.email == email }) {
            self.currentUser = student
        }
        
        saveSession()
        return response
    }
    
    func makeRequest<T: Decodable>(url: URL, method: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard let userSecret = userSecret else { throw APIError.notAuthenticated }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        guard let finalURL = components.url else { throw APIError.networkError }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        request.setValue("Bearer \(userSecret.uuidString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
        print (String(decoding: prettyData, as: UTF8.self))
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.networkError }
        
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
    
    func makeRequest<T: Decodable>(url: URL, method: String, body: Encodable) async throws -> T {
        guard let userSecret = userSecret else { throw APIError.notAuthenticated }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(userSecret.uuidString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.networkError }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(T.self, from: data)
    }
    
    func makeRequest(url: URL, method: String, body: Encodable? = nil) async throws {
        guard let userSecret = userSecret else { throw APIError.notAuthenticated }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(userSecret.uuidString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.networkError }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
    }
    
    private let userSecretKey = "savedUserSecret"
    private let cohortKey = "savedCohort"
    private let currentUserEmailKey = "savedCurrentUserEmail"
    
    func saveSession() {
        if let userSecret = userSecret {
            UserDefaults.standard.set(userSecret.uuidString, forKey: userSecretKey)
        }
        UserDefaults.standard.set(cohort, forKey: cohortKey)
        if let currentUser = currentUser {
            UserDefaults.standard.set(currentUser.email, forKey: currentUserEmailKey)
        }
    }
    
    func restoreSession() {
        if let savedSecret = UserDefaults.standard.string(forKey: userSecretKey),
           let uuid = UUID(uuidString: savedSecret) {
            userSecret = uuid
        }
        if let savedCohort = UserDefaults.standard.string(forKey: cohortKey) {
            cohort = savedCohort
        }
        if let savedEmail = UserDefaults.standard.string(forKey: currentUserEmailKey),
           let student = Student.demoStudents.first(where: { $0.email == savedEmail }) {
            currentUser = student
        }
    }
    
    func clearSession() {
        userSecret = nil
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userSecretKey)
        UserDefaults.standard.removeObject(forKey: cohortKey)
        UserDefaults.standard.removeObject(forKey: currentUserEmailKey)
    }
    
    func logout() {
        clearSession()
    }
    
    var isAuthenticated: Bool {
        return userSecret != nil
    }
}
