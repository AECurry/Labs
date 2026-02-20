//
//  ImageThemeCatalog.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

// MARK: - Theme/Image Model
struct ImageTheme: Identifiable {
    let id: String
    let imageName: String
    let displayName: String
    let description: String
    let category: Category
    
    // Category enum inside ImageTheme
    enum Category: String, CaseIterable {
        case nature, abstract, symbols, seasonal
        
        var displayName: String {
            switch self {
            case .nature: return "Nature"
            case .abstract: return "Abstract"
            case .symbols: return "Symbols"
            case .seasonal: return "Seasonal"
            }
        }
    }
}

// MARK: - Catalog Manager
struct ImageThemeCatalog {
    static var allThemes: [ImageTheme] = [
        // Nature Themes
        ImageTheme(
            id: "japanese_koi",
            imageName: "JapaneseKoi",
            displayName: "Japanese Koi",
            description: "Traditional koi fish symbolizing luck",
            category: .nature
        ),
        
        // Abstract Themes
        ImageTheme(
            id: "walking_person",
            imageName: "WalkingPerson",
            displayName: "Walking Figure",
            description: "Simple walking person symbol",
            category: .abstract
        ),
        
        // Symbol Themes
        ImageTheme(
            id: "kanji_icon",
            imageName: "KanjiMatsukiIcon",
            displayName: "Kanji Character",
            description: "Japanese character for 'increase'",
            category: .symbols
        )
    ]
    
    static func themes(in category: ImageTheme.Category) -> [ImageTheme] {
        return allThemes.filter { $0.category == category }
    }
    
    static func getTheme(by imageName: String) -> ImageTheme? {
        return allThemes.first { $0.imageName == imageName }
    }
    
    static func addTheme(_ theme: ImageTheme) {
        allThemes.append(theme)
    }
    
    static func removeTheme(withId id: String) {
        allThemes.removeAll { $0.id == id }
    }
}

