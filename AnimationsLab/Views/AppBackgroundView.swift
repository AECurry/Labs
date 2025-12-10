//
//  AppBackgroundView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/9/25.
//

/// COMPONENT: Reusable background styles for the app
/// SOLID: Open/Closed - extensible through different styles
/// USAGE: AppBackgroundView.gameStyle in MainAppView
import SwiftUI

/// A reusable animated background component for all screens
struct AppBackgroundView: View {
   
    // Controls the pulsing effect scale
    @State private var pulseAnimation = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0, blue: 0.3),
                        Color(red: 0.2, green: 0, blue: 0.4),
                        Color(red: 0.15, green: 0.0, blue: 0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                .opacity(pulseAnimation ? 0.8 : 0.4)
                .animation(
                    .easeInOut(duration: 4).repeatForever(autoreverses: true),
                    value: pulseAnimation
                )
            }
            .onAppear {
                pulseAnimation = true
            }
        }
    }
}

// Style Variants Extension

extension AppBackgroundView {
    /// Game-style background with grid pattern
    static var gameStyle: some View {
        GeometryReader { geometry in
            ZStack {
                // Black background fills entire screen
                Color.black
                
                // Grid box container (centered, specific size)
                ZStack {
                    // Gradient for the grid box
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0, blue: 0.4),
                            .black
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 150
                    )
                    
                    // Grid pattern for the box
                    Path { path in
                        let boxWidth: CGFloat = 300
                        let boxHeight: CGFloat = 500
                        
                        // Vertical lines for the box
                        for i in 0...Int(boxWidth / 50) {
                            let x = CGFloat(i) * 50
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: boxHeight))
                        }
                        
                        // Horizontal lines for the box
                        for i in 0...Int(boxHeight / 50) {
                            let y = CGFloat(i) * 50
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: boxWidth, y: y))
                        }
                    }
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                }
                .frame(width: 300, height: 500)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }
    
    /// Celebration-style background with colorful gradients
    static var celebrationStyle: some View {
        GeometryReader { geometry in
            ZStack {
                AngularGradient(
                    gradient: Gradient(colors: [
                        .blue, .purple, .pink, .orange, .yellow, .green, .blue
                    ]),
                    center: .center
                )
                .opacity(0.3)
                
                LinearGradient(
                    colors: [.black, .clear, .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                let topColors: [Color] = [.yellow, .orange, .pink, .blue]
                let bottomColors: [Color] = [.blue, .green, .purple, .cyan]
                
                ForEach(0..<12, id: \.self) { index in
                    Circle()
                        .fill(topColors[index % 4].opacity(0.2))
                        .frame(width: 8)
                        .position(
                            x: geometry.size.width * 0.1 + CGFloat(index) * geometry.size.width * 0.07,
                            y: geometry.size.height * 0.1
                        )
                        .blur(radius: 2)
                    
                    Circle()
                        .fill(bottomColors[index % 4].opacity(0.2))
                        .frame(width: 8)
                        .position(
                            x: geometry.size.width * 0.1 + CGFloat(index) * geometry.size.width * 0.07,
                            y: geometry.size.height * 0.9
                        )
                        .blur(radius: 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    VStack {
        AppBackgroundView()
            .frame(height: 200)
            .border(Color.red)
        
        AppBackgroundView.gameStyle
            .frame(height: 200)
            .border(Color.red)
        
        AppBackgroundView.celebrationStyle
            .frame(height: 200)
            .border(Color.red)
    }
}
