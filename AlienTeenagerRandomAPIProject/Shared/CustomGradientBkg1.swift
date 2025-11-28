//
//  CustomGradientBkg1.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/19/25.
//

import SwiftUI

// MARK: - Gradient Stop with Location
struct GradientStop {
    let color: Color
    let location: Double // 0.0 to 1.0
}

// MARK: - Custom Gradient Configuration
struct CustomGradientConfig {
    let stops: [GradientStop]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    // Convenience initializer for simple color arrays
    init(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) {
        let step = 1.0 / Double(colors.count - 1)
        self.stops = colors.enumerated().map { index, color in
            GradientStop(color: color, location: Double(index) * step)
        }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    // Detailed initializer for precise control
    init(stops: [GradientStop], startPoint: UnitPoint, endPoint: UnitPoint) {
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

// MARK: - Main Gradient Background View
struct CustomGradientBkg1: View { // ← CHANGED TO CustomGradientBkg1
    let gradientConfig: CustomGradientConfig
    
    // Default initializer with your custom configuration
    init() {
        self.gradientConfig = CustomGradientConfig(
            stops: [
                GradientStop(color: .deepNavy, location: 0.0),
                GradientStop(color: .majorelleBlue, location: 0.2),
                GradientStop(color: .pumpkinSpice, location: 0.45),
                GradientStop(color: .pumpkinSpice, location: 0.75),
                GradientStop(color: .cyan, location: 0.85)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // Custom initializer for different configurations
    init(gradientConfig: CustomGradientConfig) {
        self.gradientConfig = gradientConfig
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: gradientConfig.stops.map {
                Gradient.Stop(color: $0.color, location: $0.location)
            }),
            startPoint: gradientConfig.startPoint,
            endPoint: gradientConfig.endPoint
        )
        .ignoresSafeArea()
    }
}

// MARK: - Predefined Gradient Styles
extension CustomGradientBkg1 {
    // Alternative configuration
    static var customSunset: some View {
        CustomGradientBkg1( // ← CHANGED TO CustomGradientBkg1
            gradientConfig: CustomGradientConfig(
                stops: [
                    GradientStop(color: .deepNavy, location: 0.0),
                    GradientStop(color: .majorelleBlue, location: 0.25),
                    GradientStop(color: .pumpkinSpice, location: 0.5),
                    GradientStop(color: .cyan, location: 0.72),
                    GradientStop(color: .deepNavy, location: 0.91)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // Ocean style
    static var ocean: some View {
        CustomGradientBkg1( // ← CHANGED TO CustomGradientBkg1
            gradientConfig: CustomGradientConfig(
                stops: [
                    GradientStop(color: .cyan, location: 0.0),
                    GradientStop(color: .majorelleBlue, location: 0.4),
                    GradientStop(color: .deepNavy, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Preview
#Preview {
    CustomGradientBkg1()
}
