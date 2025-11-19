/*:
## App Exercise - Workout API
 
 >These exercises reinforce Swift concepts in the context of a fitness tracking app.
 
 Your workout app now features a server-side API for users to upload and retrieve their workout data to use across multiple devices. For simplicity's sake, we will not be using a real API for this exercise. Below, an APIRequest protocol has been provided, alongside a sample implementation for a `GetUserRequest` API call.
 */
import Foundation

// Protocol for defining API requests with generic Response type
protocol APIRequest {
    // The type this request will decode to (User, Workout, etc.)
    associatedtype Response
    // The actual URL request to send
    var urlRequest: URLRequest { get }
    // How to convert Data to Response
    func decodeResponse(data: Data) throws -> Response
}

// Model types for our API responses
struct User: Codable {
    let username: String
}

// Empty for now - would contain workout properties
struct Workout: Codable {
    
}

// Request to fetch a specific user by username
struct GetUserRequest: APIRequest {
    // This request returns User objects
    typealias Response = User
    let urlRequest: URLRequest
    
    init(username: String) {
        // Create URLComponents to build the request URL
        var urlComponents = URLComponents()
        // Set the API endpoint path for user lookup
        urlComponents.path = "/users"
        // Add query parameter to filter by specific username
        // This would create a URL like: /users?username=John_Doe
        urlComponents.queryItems = [URLQueryItem(name: "username", value: username)]
        
        // WARNING: Force-unwrapping URL - in production, handle optional safely
        urlRequest = URLRequest(url: urlComponents.url!)
    }
    
    // Convert JSON data from API into User object
    func decodeResponse(data: Data) throws -> User {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(User.self, from: data)
    }
}

struct GetRecentWorkoutRequest: APIRequest {
    // This request returns Workout objects
    typealias Response = Workout
    let urlRequest: URLRequest
    
    init() {
        // Create URLComponents to build the request URL
        var urlComponents = URLComponents()
        // Set the API endpoint path for fetching most recent workout
        urlComponents.path = "/workout/getLast/"
        
        // WARNING: Force-unwrapping URL without base URL - will crash
        // Currently creates invalid URL with just path "/workout/getLast/"
        // Missing: scheme (https), host (api.example.com), etc.
        urlRequest = URLRequest(url: urlComponents.url!)
    }
    
    // Convert JSON data from API into Workout object
    func decodeResponse(data: Data) throws -> Workout {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(Workout.self, from: data)
    }
}

// Service class to execute any APIRequest and return its Response type
class WorkoutAPIService {
    // Generic method that works with ANY APIRequest type
    func performRequest<R: APIRequest>(_ request: R) async throws -> R.Response {
        // Make network request
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
        // Check for HTTP errors (non-2xx status codes)
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
        
        // Decode the successful response using the request's specific decoder
        return try request.decodeResponse(data: data)
    }
}

// Test function to demonstrate the API in action
func testAPI() {
    Task {
        
        let apiService = WorkoutAPIService()
        
        let getUserRequest = GetUserRequest(username: "John_Doe")
        let user = try await apiService.performRequest(getUserRequest)
        print("User: \(user.username)")
        
        let getWorkoutRequest = GetRecentWorkoutRequest()
        let recentWorkout = try await apiService.performRequest(getWorkoutRequest)
        print("Workout: \(recentWorkout)")
    }
}

// Start the test
testAPI()
//:  Below, a class for processing APIRequests has been started for you. The performRequest function uses a generic so that it can be called with any APIRequest, and will return the appropriate type specified by that request's Response type alias. Try calling the function: first, initialize a GetUserRequest, then call performRequest(_:), passing in the GetUserRequest you created and storing the result in a constant `user`. In a comment, answer: What type will `user` be, and where was that type derived from?

// Answer given above

//:  Create another struct, `GetRecentWorkoutRequest` that conforms to APIRequest. The url path should be "/workout/getLast/", with no query items needed. The response type should be `Workout`, which you will need to create as a struct as well; for simplicity's sake you can leave the struct empty with no parameters, but it will need to conform to Codable..

// Answer given above

//:  Try calling WorkoutAPIService.performRequest(_:) again, this time with your new GetRecentWorkoutRequest. In a comment, answer: What type will the function return this time, and where was that type derived from?

// Answer given above

/*:
 [Previous](@previous)  |  page 4 of 4
  */
