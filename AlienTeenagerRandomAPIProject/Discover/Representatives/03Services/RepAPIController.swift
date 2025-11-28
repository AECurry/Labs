//
//  RepAPIController.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import Foundation

/// Concrete implementation of RepAPIControllerProtocol
class RepAPIController: RepAPIControllerProtocol {
    
    // MARK: - Properties
    private let baseURL = "https://whoismyrepresentative.com/getall_mems.php"
    
    // MARK: - Custom Errors
    enum RepresentativeAPIError: LocalizedError {
        case invalidZipCode
        case noRepresentativesFound
        case invalidResponse
        case networkError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidZipCode:
                return "Please enter a valid 5-digit zip code"
            case .noRepresentativesFound:
                return "No representatives found for this zip code"
            case .invalidResponse:
                return "Unable to parse response from server"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Public Methods
    func fetchRepresentatives(for zipCode: String) async throws -> [Representative] {
        // Validate zip code
        guard isValidZipCode(zipCode) else {
            throw RepresentativeAPIError.invalidZipCode
        }
        
        // Build URL
        guard let url = buildURL(for: zipCode) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepresentativeAPIError.invalidResponse
            }
            
            // Handle error status codes
            if httpResponse.statusCode == 400 {
                throw RepresentativeAPIError.noRepresentativesFound
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw RepresentativeAPIError.invalidResponse
            }
            
            // Parse JSON
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(RepresentativeAPIResponse.self, from: data)
            
            if apiResponse.results.isEmpty {
                throw RepresentativeAPIError.noRepresentativesFound
            }
            
            return apiResponse.results
            
        } catch let error as RepresentativeAPIError {
            throw error
        } catch is DecodingError {
            throw RepresentativeAPIError.noRepresentativesFound
        } catch {
            throw RepresentativeAPIError.networkError(error)
        }
    }
    
    // MARK: - Private Methods
    private func buildURL(for zipCode: String) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "zip", value: zipCode),
            URLQueryItem(name: "output", value: "json")
        ]
        return components?.url
    }
    
    private func isValidZipCode(_ zipCode: String) -> Bool {
        let trimmed = zipCode.trimmingCharacters(in: .whitespaces)
        return trimmed.count == 5 && trimmed.allSatisfy { $0.isNumber }
    }
}
