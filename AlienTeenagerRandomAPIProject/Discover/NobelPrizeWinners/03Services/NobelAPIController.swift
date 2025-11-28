//
//  NobelAPIController.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import Foundation

class NobelAPIController: NobelAPIControllerProtocol {
    
    // MARK: - Properties
    private let baseURL = "https://api.nobelprize.org/2.1/nobelPrizes"
    
    // MARK: - Custom Errors
    enum NobelAPIError: LocalizedError {
        case invalidURL
        case invalidResponse
        case noPrizesFound
        case networkError(Error)
        case decodingError(Error)
        case rateLimited
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid request parameters"
            case .invalidResponse:
                return "Invalid response from server"
            case .noPrizesFound:
                return "No Nobel prizes found for the specified criteria"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .decodingError(let error):
                return "Failed to parse response: \(error.localizedDescription)"
            case .rateLimited:
                return "Too many requests. Please try again later."
            }
        }
    }
    
    // MARK: - API Response Models (for decoding only)
    private struct APIResponse: Codable {
        let nobelPrizes: [APINobelPrize]
    }
    
    private struct APINobelPrize: Codable {
        let awardYear: String
        let category: APICategory
        let categoryFullName: APICategoryFullName?
        let dateAwarded: String?
        let laureates: [APILaureate]?
    }
    
    private struct APICategory: Codable {
        let en: String
        let no: String?
        let se: String?
    }
    
    private struct APICategoryFullName: Codable {
        let en: String?
    }
    
    private struct APILaureate: Codable {
        let id: String
        let knownName: APIKnownName?
        let fullName: APIFullName?
        let portion: String?
        let sortOrder: String?
        let motivation: APIMotivation?
        let wikipedia: APIWikipedia?
    }
    
    private struct APIKnownName: Codable {
        let en: String?
    }
    
    private struct APIFullName: Codable {
        let en: String?
    }
    
    private struct APIMotivation: Codable {
        let en: String?
        let se: String?
    }
    
    private struct APIWikipedia: Codable {
        let slug: String?
        let english: String?
    }
    
    // MARK: - Public Methods
    func fetchNobelPrizes(year: String? = nil, category: String? = nil, limit: Int = 25) async throws -> [NobelPrize] {
        
        guard let url = buildURL(year: year, category: category, limit: limit) else {
            throw NobelAPIError.invalidURL
        }
        
        print("🔍 Fetching from: \(url.absoluteString)")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // FIRST: Let's see the raw JSON structure
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📦 RAW API RESPONSE:")
            print("First 2000 characters:")
            print(String(jsonString.prefix(2000)))
            print("...")
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(APIResponse.self, from: data)
        
        print("✅ Found \(apiResponse.nobelPrizes.count) prizes")
        
        // Convert to app models
        let nobelPrizes = apiResponse.nobelPrizes.map { apiPrize in
            convertToAppModel(apiPrize: apiPrize)
        }
        
        if nobelPrizes.isEmpty {
            throw NobelAPIError.noPrizesFound
        }
        
        return nobelPrizes
    }
    
    func fetchCategories() async throws -> [String] {
        // Return the display categories for your UI
        return ["physics", "chemistry", "medicine", "literature", "peace", "economics"]
    }
    
    // MARK: - Private Methods
    
    private func buildURL(year: String?, category: String?, limit: Int) -> URL? {
        var components = URLComponents(string: baseURL)
        var queryItems: [URLQueryItem] = []
        
        // Add year filter if provided
        if let year = year, !year.isEmpty {
            queryItems.append(URLQueryItem(name: "nobelPrizeYear", value: year))
        }
        
        // Add category filter if provided - convert to API category code
        if let category = category, !category.isEmpty {
            let apiCategory = convertToAPICategory(category)
            queryItems.append(URLQueryItem(name: "nobelPrizeCategory", value: apiCategory))
        }
        
        // Add limit
        queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        
        // Add offset for pagination
        queryItems.append(URLQueryItem(name: "offset", value: "0"))
        
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    private func convertToAPICategory(_ displayCategory: String) -> String {
        switch displayCategory.lowercased() {
        case "physics": return "phy"
        case "chemistry": return "che"
        case "medicine": return "med"
        case "literature": return "lit"
        case "peace": return "pea"
        case "economics": return "eco"
        default: return displayCategory
        }
    }
    
    private func convertToAppModel(apiPrize: APINobelPrize) -> NobelPrize {
        let laureates = apiPrize.laureates?.map { apiLaureate in
            let laureateName = apiLaureate.knownName?.en ?? apiLaureate.fullName?.en ?? "Unknown"
            
            print("\n--- LAUREATE: \(laureateName) ---")
            print("ID: \(apiLaureate.id)")
            print("Wikipedia Slug: \(apiLaureate.wikipedia?.slug ?? "NONE")")
            print("Wikipedia English: \(apiLaureate.wikipedia?.english ?? "NONE")")
            
            // Test if the portrait endpoint exists
            let portraitURL = URL(string: "https://api.nobelprize.org/2/laureate/\(apiLaureate.id)/portrait")
            print("Portrait URL: \(portraitURL?.absoluteString ?? "INVALID")")
            
            return Laureate(
                id: apiLaureate.id,
                fullName: FullName(en: apiLaureate.fullName?.en ?? apiLaureate.knownName?.en),
                portion: apiLaureate.portion,
                sortOrder: apiLaureate.sortOrder,
                motivation: Motivation(
                    en: apiLaureate.motivation?.en,
                    se: apiLaureate.motivation?.se
                ),
                wikipedia: apiLaureate.wikipedia.map { apiWiki in
                    WikipediaInfo(
                        slug: apiWiki.slug,
                        english: apiWiki.english
                    )
                }
            )
        }
        
        return NobelPrize(
            awardYear: apiPrize.awardYear,
            category: apiPrize.category.en.lowercased(),
            categoryFullName: apiPrize.categoryFullName?.en,
            dateAwarded: apiPrize.dateAwarded,
            laureates: laureates
        )
    }
}
