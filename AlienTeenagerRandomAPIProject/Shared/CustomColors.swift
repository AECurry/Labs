//
//  CustomColors.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/19/25.
//

import SwiftUI

// MARK: - Custom Colors
extension Color {
    // Your App Colors - Using your exact custom colors
    static let deepNavy = Color(hex: "0D1642")
    static let majorelleBlue = Color(hex: "6F57E5")
    static let pumpkinSpice = Color(hex: "FE6700")
    static let cyan = Color(hex: "01FDF8")
    static let alabasterGray = Color(hex: "DBDEDE")
    static let charcoal = Color(hex: "5B5B5B")
   
    
    // Optional: Add semantic names for better usage
    static let primaryBrand = Color.majorelleBlue
    static let accentColor = Color.pumpkinSpice
    static let backgroundDark = Color.deepNavy
    static let neonAccent = Color.cyan
    static let lightGray1 = Color.alabasterGray
    static let darkGray1 = Color.charcoal
}

// MARK: - Hex Color Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

