//
//  NobelPrizeDataModel.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import Foundation

// MARK: - API Response Model
struct NobelPrizeAPIResponse: Codable {
    let nobelPrizes: [NobelPrize]
}

// MARK: - Nobel Prize Model
struct NobelPrize: Identifiable, Codable, Equatable {
    var id: String { "\(awardYear)-\(category)" }
    
    let awardYear: String
    let category: String
    let categoryFullName: String?
    let dateAwarded: String?
    let laureates: [Laureate]?
    
    // Computed properties for easier access
    var displayCategory: String {
        category.capitalized
    }
    
    var laureateNames: String {
        laureates?.map { $0.fullName?.en ?? "Unknown" }.joined(separator: ", ") ?? "No laureates"
    }
    
    var motivation: String? {
        laureates?.first?.motivation?.en
    }
}

// MARK: - Laureate Model
struct Laureate: Identifiable, Codable, Equatable {
    let id: String
    let fullName: FullName?
    let portion: String?
    let sortOrder: String?
    let motivation: Motivation?
    let wikipedia: WikipediaInfo?  // ← Add this for images
}

// MARK: - Wikipedia Info Model (contains image URLs)
struct WikipediaInfo: Codable, Equatable {
    let slug: String?
    let english: String?
    
    // Computed property to get image URL
    var imageURL: URL? {
        // Nobel Prize images follow this pattern
        if let slug = slug {
            return URL(string: "https://www.nobelprize.org/images/\(slug)-1280.jpg")
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case slug
        case english = "english"
    }
}

// MARK: - Full Name Model
struct FullName: Codable, Equatable {
    let en: String?
}

// MARK: - Motivation Model (can be in different languages)
struct Motivation: Codable, Equatable {
    let en: String?
    let se: String?
}

// MARK: - Nobel Prize State
struct NobelPrizeState {
    var nobelPrizes: [NobelPrize] = []
    var categories: [String] = []
    var isLoading = false
    var error: String?
    var searchYear: String = ""
    var selectedCategory: String = ""
    var hasSearched = false
    
    var isEmpty: Bool {
        nobelPrizes.isEmpty && hasSearched && !isLoading
    }
}

