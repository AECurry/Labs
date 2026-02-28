//
//  APIService.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import Foundation

final class APIService: APIServiceProtocol {
    private let baseURL = "https://randomuser.me/api/"
    private let session: URLSession
    
    init(session: URLSession = {
     
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        return URLSession(configuration: config)
    }()) {
        self.session = session
    }
    
    func fetchUsers(settings: Settings) async throws -> [User] {
        var components = URLComponents(string: baseURL)
        
        var queryItems = [
            URLQueryItem(name: "results", value: "\(settings.numberOfUsers)")
        ]
        
        if !settings.selectedFields.isEmpty {
            let fieldsString = settings.selectedFields.joined(separator: ",")
            queryItems.append(URLQueryItem(name: "inc", value: fieldsString))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Fetching: \(url.absoluteString)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.networkError(NSError(domain: "", code: -1))
            }
            
            let decoder = JSONDecoder()
            let userResponse = try decoder.decode(UserResponse.self, from: data)
            return userResponse.results
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
