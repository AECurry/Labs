//
//  ThemeBackground.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

// MARK: - Protocol (Dependency Inversion Principle)
protocol ThemeProvider {
    var themeColor: Color { get }
    var displayName: String { get }
}

// MARK: - Theme Service (Single Responsibility)
@Observable
final class ThemeBackground {
    var currentTheme: any ThemeProvider
    
    init(theme: any ThemeProvider = DragonTheme.inferno) {
        self.currentTheme = theme
    }
    
    var themeColor: Color {
        currentTheme.themeColor
    }
    
    // Get dragon theme for special effects
    var dragonTheme: DragonTheme? {
        currentTheme as? DragonTheme
    }
    
    func setTheme(_ theme: any ThemeProvider) {
        currentTheme = theme
    }
    
    // MARK: - Background View Provider
    /// Returns the appropriate background view for the current theme
    @ViewBuilder
    func backgroundView() -> some View {
        if let dragonTheme = currentTheme as? DragonTheme {
            DragonAuraBackground(theme: dragonTheme)
        } else {
            // Fallback for non-dragon themes
            themeColor.opacity(0.1)
                .ignoresSafeArea()
        }
    }
}

// MARK: - Dragon Theme with Epic Aura Effects
enum DragonTheme: String, CaseIterable, Identifiable, ThemeProvider {
    case inferno = "Inferno"
    case oceanic = "Oceanic"
    case storm = "Storm"
    case forest = "Forest"
    case cosmic = "Cosmic"
    case shadow = "Shadow"
    case sunset = "Sunset"
    
    var id: String { rawValue }
    var displayName: String { rawValue }
    
    // Primary theme color
    var themeColor: Color {
        switch self {
        case .inferno: return .orange
        case .oceanic: return .blue
        case .storm: return .cyan
        case .forest: return .green
        case .cosmic: return .purple
        case .shadow: return .gray
        case .sunset: return .pink
        }
    }
    
    // Dark atmospheric base color
    var baseColor: Color {
        switch self {
        case .inferno: return Color(red: 0.15, green: 0.05, blue: 0.05)
        case .oceanic: return Color(red: 0.05, green: 0.1, blue: 0.2)
        case .storm: return Color(red: 0.1, green: 0.15, blue: 0.25)
        case .forest: return Color(red: 0.05, green: 0.15, blue: 0.08)
        case .cosmic: return Color(red: 0.1, green: 0.05, blue: 0.2)
        case .shadow: return Color(red: 0.08, green: 0.08, blue: 0.1)
        case .sunset: return Color(red: 0.2, green: 0.1, blue: 0.15)
        }
    }
    
    // Glowing aura gradient (radial burst effect)
    var auraGradient: RadialGradient {
        switch self {
        case .inferno:
            return RadialGradient(
                colors: [
                    Color.orange.opacity(0.4),
                    Color.red.opacity(0.2),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 500
            )
        case .oceanic:
            return RadialGradient(
                colors: [
                    Color.blue.opacity(0.4),
                    Color.cyan.opacity(0.2),
                    Color.clear
                ],
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 500
            )
        case .storm:
            return RadialGradient(
                colors: [
                    Color.cyan.opacity(0.4),
                    Color.blue.opacity(0.2),
                    Color.purple.opacity(0.1),
                    Color.clear
                ],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
        case .forest:
            return RadialGradient(
                colors: [
                    Color.green.opacity(0.4),
                    Color.mint.opacity(0.2),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
        case .cosmic:
            return RadialGradient(
                colors: [
                    Color.purple.opacity(0.5),
                    Color.indigo.opacity(0.3),
                    Color.blue.opacity(0.1),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 500
            )
        case .shadow:
            return RadialGradient(
                colors: [
                    Color.gray.opacity(0.3),
                    Color.black.opacity(0.2),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
        case .sunset:
            return RadialGradient(
                colors: [
                    Color.pink.opacity(0.4),
                    Color.orange.opacity(0.3),
                    Color.yellow.opacity(0.1),
                    Color.clear
                ],
                center: .topLeading,
                startRadius: 0,
                endRadius: 500
            )
        }
    }
    
    // Card glow effect (subtle shadow that matches element)
    var cardGlowColor: Color {
        switch self {
        case .inferno: return Color.orange.opacity(0.3)
        case .oceanic: return Color.blue.opacity(0.3)
        case .storm: return Color.cyan.opacity(0.3)
        case .forest: return Color.green.opacity(0.3)
        case .cosmic: return Color.purple.opacity(0.3)
        case .shadow: return Color.gray.opacity(0.2)
        case .sunset: return Color.pink.opacity(0.3)
        }
    }
    
    var icon: String {
        switch self {
        case .inferno: return "flame.fill"
        case .oceanic: return "drop.fill"
        case .storm: return "cloud.bolt.fill"
        case .forest: return "leaf.fill"
        case .cosmic: return "sparkles"
        case .shadow: return "moon.fill"
        case .sunset: return "sun.horizon.fill"
        }
    }
}

// MARK: - Dragon Aura Background View
struct DragonAuraBackground: View {
    let theme: DragonTheme
    
    var body: some View {
        ZStack {
            // Dark atmospheric base
            theme.baseColor
                .ignoresSafeArea()
            
            // Glowing aura overlay
            theme.auraGradient
                .ignoresSafeArea()
                .blendMode(.screen)
            
            // Subtle noise/texture overlay (optional)
            Color.white.opacity(0.02)
                .ignoresSafeArea()
                .blendMode(.overlay)
        }
    }
}
