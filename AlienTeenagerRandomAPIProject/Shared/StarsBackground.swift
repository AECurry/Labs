//
//  StarsBackground.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/19/25.
//

import SwiftUI

// MARK: - Realistic Stars Background Component
// Animated star background - fills entire screen
struct StarsBackground: View {
    // State to hold the array of stars for animation
    @State private var stars: [Star] = []
    
    // Star structure representing individual animated stars
    struct Star: Identifiable {
        let id = UUID()          // Unique identifier for each star
        let size: CGFloat        // Diameter of the star (1-4 points for realism)
        let x: CGFloat          // Horizontal starting position (0-1 normalized)
        let y: CGFloat          // Vertical starting position (0-1 normalized)
        let opacity: Double     // Brightness level (0.3-1.0)
        let twinkleSpeed: Double // Twinkle animation speed (1-4 seconds)
        let color: Color        // Star color (white, cyan, or light blue)
    }
    
    init() {
        // Create initial stars when the view is initialized
        // Generate 150 stars for a rich starfield effect
        _stars = State(initialValue: (0..<150).map { _ in
            // Randomly assign one of three colors to each star
            let colors: [Color] = [.white, .cyan, Color(red: 0.7, green: 0.8, blue: 1.0)]
            let randomColor = colors.randomElement() ?? .white
            
            return Star(
                size: CGFloat.random(in: 1...4),          // Realistic star sizes
                x: CGFloat.random(in: 0...1),             // Random horizontal position
                y: CGFloat.random(in: 0...1),             // Random vertical position
                opacity: Double.random(in: 0.3...1.0),    // Varying brightness
                twinkleSpeed: Double.random(in: 8...16),   // Twinkle speed
                color: randomColor                        // Assign random color
            )
        })
    }
    
    var body: some View {
        // Use GeometryReader to get the current screen size dynamically
        GeometryReader { geometry in
            ZStack {
              
                
                // Animated stars - create each star from the array
                ForEach(stars) { star in
                    RealisticStarView(
                        size: star.size,
                        x: star.x,
                        y: star.y,
                        opacity: star.opacity,
                        twinkleSpeed: star.twinkleSpeed,
                        color: star.color,
                        screenSize: geometry.size
                    )
                }
                
                // Add some occasional shooting stars
                ShootingStarView(screenSize: geometry.size)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()  // Make background extend under safe areas
    }
}

// MARK: - Realistic Star View
// Individual star view with twinkling animation
struct RealisticStarView: View {
    let size: CGFloat          // Star diameter
    let x: CGFloat            // Normalized horizontal position (0-1)
    let y: CGFloat            // Normalized vertical position (0-1)
    let opacity: Double       // Base opacity
    let twinkleSpeed: Double  // Twinkle animation speed
    let color: Color         // Star color
    let screenSize: CGSize   // Current screen dimensions
    
    // Animation state properties
    @State private var currentOpacity: Double
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    init(size: CGFloat, x: CGFloat, y: CGFloat, opacity: Double, twinkleSpeed: Double, color: Color, screenSize: CGSize) {
        self.size = size
        self.x = x
        self.y = y
        self.opacity = opacity
        self.twinkleSpeed = twinkleSpeed
        self.color = color
        self.screenSize = screenSize
        self._currentOpacity = State(initialValue: opacity)
    }
    
    var body: some View {
        ZStack {
            // Main star body with glow effect
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .opacity(currentOpacity)
            
            // Glow effect for brighter stars
            if opacity > 0.7 {
                Circle()
                    .fill(color)
                    .frame(width: size * 2, height: size * 2)
                    .opacity(currentOpacity * 0.3)
                    .blur(radius: 1)
            }
        }
        .position(
            x: x * screenSize.width,
            y: y * screenSize.height
        )
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            startAnimations()
        }
    }
    
    // MARK: - Animation Control
    private func startAnimations() {
        // Twinkling animation - stars fade in and out
        withAnimation(.easeInOut(duration: twinkleSpeed).repeatForever(autoreverses: true)) {
            currentOpacity = opacity * 0.3  // Dim phase
        }
        
        // Delayed start for varied twinkling
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...2)) {
            withAnimation(.easeInOut(duration: twinkleSpeed).repeatForever(autoreverses: true)) {
                currentOpacity = opacity  // Back to full brightness
            }
        }
        
        // Subtle scaling for larger stars
        if size > 2.5 {
            withAnimation(.easeInOut(duration: twinkleSpeed * 1.5).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
        }
        
        // Slow rotation for sparkle effect on larger stars
        if size > 3 {
            withAnimation(.linear(duration: twinkleSpeed * 8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Shooting Star View
// Occasional shooting stars across the screen
struct ShootingStarView: View {
    let screenSize: CGSize
    @State private var shootingStars: [ShootingStar] = []
    
    struct ShootingStar: Identifiable {
        let id = UUID()
        let startPoint: CGPoint
        let endPoint: CGPoint
        let speed: Double
        let size: CGFloat
    }
    
    var body: some View {
        ForEach(shootingStars) { star in
            ShootingStarTrail(
                startPoint: star.startPoint,
                endPoint: star.endPoint,
                speed: star.speed,
                size: star.size
            )
        }
        .onAppear {
            startShootingStarGenerator()
        }
    }
    
    private func startShootingStarGenerator() {
        // Generate a shooting star every 5-15 seconds
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 4...8), repeats: true) { _ in
            let newStar = createShootingStar()
            shootingStars.append(newStar)
            
            // Remove the star after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + newStar.speed) {
                shootingStars.removeAll { $0.id == newStar.id }
            }
        }
    }
    
    private func createShootingStar() -> ShootingStar {
        let startX = CGFloat.random(in: 0...screenSize.width)
        let angle = Double.random(in: -45...45)
        let distance = screenSize.width * 1.5
        
        return ShootingStar(
            startPoint: CGPoint(x: startX, y: 0),
            endPoint: CGPoint(
                x: startX + distance * CGFloat(cos(angle * .pi / 180)),
                y: screenSize.height * 1.5
            ),
            speed: Double.random(in: 1...3),
            size: CGFloat.random(in: 2...4)
        )
    }
}

// MARK: - Shooting Star Trail
struct ShootingStarTrail: View {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let speed: Double
    let size: CGFloat
    
    @State private var position: CGPoint
    @State private var opacity: Double = 1.0
    
    init(startPoint: CGPoint, endPoint: CGPoint, speed: Double, size: CGFloat) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.speed = speed
        self.size = size
        self._position = State(initialValue: startPoint)
    }
    
    var body: some View {
        ZStack {
            // Main star
            Circle()
                .fill(.white)
                .frame(width: size, height: size)
            
            // Trail
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.white, .white.opacity(0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 8, height: size * 0.5)
                .rotationEffect(.degrees(45))
        }
        .position(position)
        .opacity(opacity)
        .onAppear {
            withAnimation(.linear(duration: speed)) {
                position = endPoint
                opacity = 0.0
            }
        }
    }
}


// MARK: - Preview
#Preview {
        StarsBackground()
}

