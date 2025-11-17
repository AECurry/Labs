//
//  ColorExtensions.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Hex Color Initializer
/// This is the custom color system for the entire app - it defines all the colors used throughout the Mountainland Technical College calendar application.
/// Supports 6-character hex strings (e.g., "FF5733", "76001F")
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)  // Remove non-hex characters
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)  // Convert hex string to integer
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)  // Extract RGB components
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)  // Create Color with 0-1 values
    }
}

// MARK: - Mountainland Technical College Color Palette
/// Comprehensive color system for Mountainland Technical College branding
/// Provides consistent colors across the entire application
struct MountainlandColors {
    // MARK: - Primary Brand Colors
    /// Core brand colors from Mountainland Technical College's official palette
    static let white = Color(hex: "FEFFFE")           // Clean white with slight off-white tint
    static let burgundy1 = Color(hex: "76001F")       // Primary burgundy - main brand color
    static let burgundy2 = Color(hex: "890022")       // Secondary burgundy - slightly lighter
    static let burgundy3 = Color(hex: "76001F").opacity(0.5)  // Transparent burgundy for overlays
    static let smokeyBlack = Color(hex: "191612")     // Dark brown/black for text and accents
    static let carolinaBlue = Color(hex: "6AACDA")    // Accent blue for highlights and CTAs
    static let pigmentGreen = Color(hex: "1D9944")    // Success green for positive states
    static let smokeWhite = Color(hex: "F3F1F0")      // Warm off-white for backgrounds
    static let platinum = Color(hex: "DDDDDC")        // Light gray for secondary elements
    static let battleshipGray = Color(hex: "999999")  // Medium gray for disabled states
    
    // MARK: - Semantic Colors
    /// Semantic color names for consistent usage throughout the app
    static var primaryBrand: Color { burgundy1 }      // Primary brand color - use for main elements
    static var secondaryBrand: Color { burgundy2 }    // Secondary brand color - use for variations
    static var accentBrand: Color { carolinaBlue }    // Accent color - use for highlights
    static var success: Color { pigmentGreen }        // Success state - use for confirmations
    
    // MARK: - Adaptive Colors
    /// Dynamic colors that automatically adjust for light/dark mode
    
    /// Adaptive background color - white in light mode, smokey black in dark mode
    static var adaptiveBackground: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(smokeyBlack) : UIColor(white)
        })
    }
    
    /// Adaptive card background - smoke white in light mode, smokey black in dark mode
    static var adaptiveCard: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(smokeyBlack) : UIColor(smokeWhite)
        })
    }
    
    /// Adaptive primary text - smokey black in light mode, white in dark mode
    static var adaptiveTextPrimary: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(white) : UIColor(smokeyBlack)
        })
    }
    
    /// Adaptive secondary text - consistent battleship gray in both modes
    static var adaptiveTextSecondary: Color {
        battleshipGray
    }
    
    // MARK: - Gradients (for future use)
    /// Brand gradient combining burgundy and blue colors
    static func mountainlandGradient(startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> LinearGradient {
        return LinearGradient(
            colors: [burgundy1, burgundy2, carolinaBlue],  // Burgundy to blue transition
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

// MARK: - Convenience Typealias
/// Short alias for easier access to Mountainland Colors
typealias MTC = MountainlandColors

// MARK: - Usage Examples
/*
// Text with brand colors
Text("Mountainland Tech")
    .foregroundColor(MTC.primaryBrand)
    .background(MTC.adaptiveBackground)

// Card with adaptive styling
CardView()
    .background(MTC.adaptiveCard)
    .border(MTC.platinum)

// Success indicator
CompletionIndicator()
    .foregroundColor(MTC.success)
*/
