//
//  APIServices-Core.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/2/26.
//

import Foundation

// MARK: - Generic Request Methods
extension APIController {
    
    /// Comprehensive logging and fixed authorization header
    func makeRequest<T: Decodable>(url: URL, method: String, body: Encodable? = nil, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard let userSecret = self.userSecret else {
            print("❌ API Error: Not authenticated - userSecret is nil")
            throw APIError.notAuthenticated
        }
        
        var finalURL = url
        if let queryItems = queryItems, !queryItems.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let urlWithQuery = components?.url { finalURL = urlWithQuery }
        }
        
        print("🌐 \(method) \(finalURL.absoluteString)")
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        
        
        // According to instructor: "Bearer <<access-token>>" in Authorization header
        let bearerToken = "Bearer \(userSecret.uuidString)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        print("🔑 Authorization Header: \(bearerToken)")
        
        if method == "POST" || method == "PUT" || method == "PATCH" {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
            
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("📦 Request Body: \(bodyString)")
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Print raw response for debugging
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 Raw Response: \(responseString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Network Error: Invalid response type")
            throw APIError.networkError
        }
        
        print("📊 Status Code: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ Server Error: Status code \(httpResponse.statusCode)")
            
            // Print response headers for debugging
            print("📋 Response Headers: \(httpResponse.allHeaderFields)")
            
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedResponse = try decoder.decode(T.self, from: data)
            print("✅ Successfully decoded response of type \(T.self)")
            return decodedResponse
        } catch {
            print("❌ Decoding Error: \(error)")
            print("📦 Data that failed to decode: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
            throw APIError.decodingError
        }
    }
    
    /// FIXED: Added logging for void requests
    func makeRequest(url: URL, method: String, body: Encodable? = nil, queryItems: [URLQueryItem]? = nil) async throws {
        guard let userSecret = self.userSecret else {
            print("❌ API Error: Not authenticated")
            throw APIError.notAuthenticated
        }
        
        var finalURL = url
        if let queryItems = queryItems, !queryItems.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            if let urlWithQuery = components?.url { finalURL = urlWithQuery }
        }
        
        print("🌐 \(method) \(finalURL.absoluteString)")
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        
        // FIXED: Authorization header with Bearer token
        let bearerToken = "Bearer \(userSecret.uuidString)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        print("🔑 Authorization Header: \(bearerToken)")
        
        if method == "POST" || method == "PUT" || method == "PATCH" {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
            
            if let bodyString = String(data: request.httpBody!, encoding: .utf8) {
                print("📦 Request Body: \(bodyString)")
            }
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Network Error: Invalid response type")
            throw APIError.networkError
        }
        
        print("📊 Status Code: \(httpResponse.statusCode)")
        
        // Print response for debugging
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 Raw Response: \(responseString)")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ Server Error: Status code \(httpResponse.statusCode)")
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        print("✅ Success: \(method) request completed successfully")
    }
}
