//
//  ColorHelper.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI

struct ColorHelper {
    static func colorFromString(_ colorName: String) -> (background: Color, text: Color) {
        let lowercased = colorName.lowercased()
        
        // Determine background color
        let backgroundColor: Color
        switch lowercased {
        case "blue", "dark blue", "light blue", "navy", "denim":
            backgroundColor = .blue
        case "black", "charcoal", "black/white":
            backgroundColor = .black
        case "white":
            backgroundColor = .white
        case "red", "plaid", "white/red":
            backgroundColor = .red
        case "green", "olive":
            backgroundColor = .green
        case "yellow", "khaki":
            backgroundColor = .yellow
        case "brown", "tan":
            backgroundColor = .brown
        case "gray", "grey":
            backgroundColor = .gray
        case "pink":
            backgroundColor = .pink
        case "purple":
            backgroundColor = .purple
        case "orange", "beige":
            backgroundColor = .orange
        default:
            backgroundColor = .blue
        }
        
        // Determine text color (black for white/light backgrounds)
        let textColor: Color
        if lowercased == "white" || lowercased.contains("beige") {
            textColor = .black
        } else {
            textColor = .white
        }
        
        return (backgroundColor, textColor)
    }
}
