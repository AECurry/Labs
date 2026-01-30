//
//  APIController.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 1/29/26.
//

// MARK: - API Controller: The App's Communication Hub
/// This is the brain that connects our app to the internet - it's like the app's personal messenger that knows how to talk to the server.
/// It handles student login, fetches lesson plans from the calendar, and sends feedback to teachers.
/// Follows the Single Responsibility Principle - only handles network communication, nothing else.

import Foundation

// MARK: - API Service Protocol
/// Defines what communication methods our app needs from the server.
/// Think of this as a contract that says "If you want to be our server messenger, you must know how to do these four things."
protocol CalendarAndTodayAPIService {
    /// Ask the server for today's lesson plan
    func fetchDailyContent(for date: Date) async throws -> CalendarEntry?
    
    /// Get ALL the lessons for the whole calendar (for monthly view)
    func fetchAllEntries() async throws -> [CalendarEntry]
    
    /// Log a student in with their email and password
    func login(email: String, password: String) async throws -> AuthResponse
    
    /// Send feedback about a lesson to the teacher
    func submitFeedback(lessonID: String, whatWentWell: String, stillConfused: String, suggestions: String) async throws
}

// MARK: - Network Error Enum
/// Special error types for internet problems - helps us know exactly what went wrong.
/// This is like having different error codes for "wrong password" vs "server is down" vs "internet disconnected"
enum APIError: Error {
    case invalidURL               // The web address we tried to use was broken
    case invalidResponse          // Server replied with garbage (not proper HTTP)
    case statusCode(Int)          // Server said "no" with a specific error number (404, 500, etc.)
    case decodingError(String)    // Server sent data, but we couldn't understand it
    case noData                   // Server replied but with empty hands
    case unauthorized             // "You're not allowed here!" (usually wrong password)
    case networkError(Error)      // General internet problem (no connection, timeout)
}

// MARK: - Authentication Model
/// What the server sends back when a student logs in successfully.
/// This is like getting your student ID card after showing your credentials at the front desk.
struct AuthResponse: Codable {
    let userUUID: String      // Your unique student number in the system
    let secret: String        // Special key that proves who you are for future requests
    let lastName: String      // Your last name for personalization
    let email: String         // Your email address (used for login)
    let firstName: String     // Your first name for greetings
    let userName: String      // Your username in the system
}

// MARK: - Calendar Data Models (These should match your API response)
/// How the server describes a single day's lesson plan.
/// This is the raw format that comes from the internet before we clean it up for our app.
struct CalendarAPIDay: Codable, Identifiable {
    let id: String                    // Unique day identifier from server
    let date: String                  // Lesson date in computer-friendly ISO format
    let lessonID: String              // Which lesson this is (e.g., "TT14")
    let lessonName: String            // Human-readable lesson title
    let mainObjective: String         // What students should learn today
    let readingDue: String            // Reading assignments
    let assignmentsDue: [APIAssignment] // Homework due today
    let newAssignments: [APIAssignment] // New homework assigned today
    let codeChallenge: String         // Daily coding practice
    let wordOfTheDay: String          // Vocabulary term
    let instructor: String            // Teacher's name
    let lessonOutline: String         // Detailed lesson plan in markdown
}

/// How the server describes a single assignment.
/// This gets converted to our app's Assignment model for use in cards and lists.
struct APIAssignment: Codable {
    let assignmentID: String          // Server's ID for this assignment
    let title: String                 // What the assignment is called
    let dueDate: String               // When it's due (ISO format)
    let lessonID: String              // Which lesson it belongs to
    let assignmentType: String        // "lab", "project", "codeChallenge", etc.
    let markdownDescription: String   // Full instructions with formatting
    let completionDate: String?       // When student finished it (or nil if not done)
}

/// Container for multiple calendar days from the server.
/// The server sends back a bundle of days, not just one at a time.
struct CalendarAPIResponse: Codable {
    let calendarEntries: [CalendarAPIDay]  // Array of lesson days
}

// MARK: - Main API Controller
/// The actual messenger that talks to the server. Implements all four required methods.
/// Uses a smart "mock mode" for testing without internet - perfect for development!
class APIController: CalendarAndTodayAPIService {
    // MARK: - Singleton Instance
    /// There's only one messenger for the whole app - everyone uses this same instance.
    /// This prevents confusion and keeps our authentication consistent.
    static let shared = APIController()
    
    // MARK: - Configuration Properties
    /// The main address of our school's server where all the data lives.
    /// Using default internal access - accessible to all files in the same module (app)
    let baseURL = "https://social-media-app.ryanplitt.com"
    
    /// Secret key we get after logging in - we show this to prove who we are.
    /// Like keeping your student ID in your pocket after checking in.
    /// Using default internal access - can be read and written by all files in the module
    var authToken: String?
    
    /// Development flag - when true, uses fake data instead of real internet calls.
    /// Perfect for testing on the bus or when the server is being repaired!
    var useMockData = false
    
    // MARK: - Private Initializer
    /// Only APIController can create itself - this enforces the singleton pattern.
    /// Prevents accidentally creating multiple messengers that get out of sync.
    private init() {}
    
    // MARK: - Authentication
    /// Logs a student into the system with their email and password.
    /// This is the digital version of showing your ID at the school entrance.
    /// - Parameters:
    ///   - email: Student's registered email address
    ///   - password: Student's secret password
    /// - Returns: AuthResponse with user info and authentication token
    /// - Throws: APIError if login fails (wrong password, server down, etc.)
    func login(email: String, password: String) async throws -> AuthResponse {
        // Check if we should use fake data for testing
        if useMockData {
            return try await mockLogin(email: email, password: password)
        }
        
        // Build the URL for the login endpoint
        let endpoint = "/auth/login"
        let urlString = baseURL + endpoint
        
        // Make sure the URL is valid (safety check)
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        // Create the login data (email + password) as JSON
        let loginData = ["email": email, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: loginData)
        
        // Prepare the HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // We're sending data to the server
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData  // Attach our login credentials
        
        // Send the request and wait for response (async/await makes this clean!)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check if we got a proper HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Check if login was successful (200-299 = good, 401 = wrong password)
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                throw APIError.unauthorized  // "Wrong password!"
            }
            throw APIError.statusCode(httpResponse.statusCode)  // Some other server error
        }
        
        // Try to understand the server's response
        let decoder = JSONDecoder()
        do {
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            // Store the secret token for future requests - like keeping your student ID
            self.authToken = authResponse.secret
            return authResponse
        } catch {
            throw APIError.decodingError("Failed to decode auth response: \(error)")
        }
    }
    
    // MARK: - Utility Methods (App Lifecycle)
    /// Logs the user out by clearing their authentication token.
    /// Like throwing away your student ID when you leave the building.
    func logout() {
        authToken = nil
    }
    
    /// Checks if a user is currently logged in.
    /// Quick way to see if we have permission to make requests.
    var isAuthenticated: Bool {
        return authToken != nil
    }
    
    /// Manually sets an authentication token (for testing or special cases).
    func setAuthToken(_ token: String) {
        authToken = token
    }
    
    // MARK: - Mock Login Helper
    /// Fake login for testing without internet or server access.
    /// Always succeeds with sample Ann Curry data from your screenshot!
    /// Using internal access so implementation file can use it
    func mockLogin(email: String, password: String) async throws -> AuthResponse {
        // Simulate network delay (makes it feel real!)
        try await Task.sleep(nanoseconds: 500_000_000) // Half-second delay
        
        // For demo purposes, accept any password
        return AuthResponse(
            userUUID: "1A4FD60D-A92C-434D-90BF-89572CAA5C7B",
            secret: "C289C852-9FAC-447C-B0A7-AE9094B73636",
            lastName: "Curry",
            email: email,
            firstName: "Ann-Elaine",
            userName: "ann-elaine.curry"
        )
    }
}
