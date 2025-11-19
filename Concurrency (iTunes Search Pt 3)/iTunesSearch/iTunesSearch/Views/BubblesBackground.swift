//
//  BubblesBackground.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/14/25.
//

import SwiftUI

// MARK: - Realistic Bubbles Background Component
// Animated bubble background - fills entire screen
struct BubblesBackground: View {
    // State to hold the array of bubbles for animation
    @State private var bubbles: [Bubble] = []
    
    // Bubble structure representing individual animated bubbles with enhanced properties
    struct Bubble: Identifiable {
        let id = UUID()          // Unique identifier for each bubble
        let size: CGFloat        // Diameter of the bubble (20-80 points for realism)
        let x: CGFloat          // Horizontal starting position (0-1 normalized)
        let y: CGFloat          // Vertical starting position (0.5-1.5, some start below screen)
        let opacity: Double     // Transparency level (0.15-0.3 for better visibility)
        let speed: Double       // Wobble animation speed (4-12 seconds for slower movement)
        let riseSpeed: Double   // Rising animation speed (4-12 seconds for much slower rise)
        let color: Color        // Bubble color (blue, pink, or purple)
    }
    
    init() {
        // Create initial bubbles when the view is initialized
        // Generate 12 bubbles with random properties for a rich effect
        _bubbles = State(initialValue: (0..<12).map { _ in
            // Randomly assign one of three colors to each bubble
            let colors: [Color] = [.blue, .purple, .pink]
            let randomColor = colors.randomElement() ?? .blue
            
            return Bubble(
                size: CGFloat.random(in: 20...80),        // Realistic bubble sizes
                x: CGFloat.random(in: 0...1),             // Random horizontal starting position
                y: CGFloat.random(in: 0.5...1.5),         // Some bubbles start below screen for staggered appearance
                opacity: Double.random(in: 0.15...0.3),   // Increased opacity for better visibility
                speed: Double.random(in: 16...32),        // SLOWER wobble speed for graceful movement
                riseSpeed: Double.random(in: 24...48),    // MUCH SLOWER rise speed for relaxed floating
                color: randomColor                        // Assign random color to bubble
            )
        })
    }
    
    var body: some View {
        // Use GeometryReader to get the current screen size dynamically
        GeometryReader { geometry in
            ZStack {
                // Ocean-like gradient background for bubbles to float over
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.2),      // Primary blue tone
                        Color.cyan.opacity(0.15),     // Middle cyan tone
                        Color.purple.opacity(0.1)     // Accent purple tone
                    ],
                    startPoint: .top,                 // Gradient starts at top
                    endPoint: .bottom                 // Gradient ends at bottom
                )
                
                // Animated realistic bubbles - create each bubble from the array
                ForEach(bubbles) { bubble in
                    RealisticBubbleView(
                        size: bubble.size,
                        x: bubble.x,
                        y: bubble.y,
                        opacity: bubble.opacity,
                        speed: bubble.speed,
                        riseSpeed: bubble.riseSpeed,
                        color: bubble.color,           // Pass the assigned color to the bubble view
                        screenSize: geometry.size
                    )
                }
            }
        }
        .ignoresSafeArea()  // Make background extend under safe areas (notch, home indicator)
    }
}

// MARK: - Realistic Bubble View
// Individual bubble view with complex animations and realistic appearance
struct RealisticBubbleView: View {
    let size: CGFloat          // Bubble diameter
    let x: CGFloat            // Normalized horizontal position (0-1)
    let y: CGFloat            // Normalized vertical position (0-1)
    let opacity: Double       // Bubble transparency
    let speed: Double        // Base animation speed
    let riseSpeed: Double    // Rising animation duration
    let color: Color         // Bubble base color (blue, purple, or pink)
    let screenSize: CGSize   // Current screen dimensions
    
    // Animation state properties
    @State private var currentY: CGFloat      // Current vertical position for rising animation
    @State private var xWobble: CGFloat = 0   // Horizontal wobble offset
    @State private var scale: CGFloat = 1.0   // Scale for pulsing effect
    @State private var shimmerOffset: CGFloat = -50 // Reduced initial shimmer offset
    @State private var rotation: Double = 0   // Rotation angle
    @State private var currentColor: Color    // Current bubble color for animation
    
    init(size: CGFloat, x: CGFloat, y: CGFloat, opacity: Double, speed: Double, riseSpeed: Double, color: Color, screenSize: CGSize) {
        self.size = size
        self.x = x
        self.y = y
        self.opacity = opacity
        self.speed = speed
        self.riseSpeed = riseSpeed
        self.color = color
        self.screenSize = screenSize
        // Initialize currentY based on normalized y position and screen height
        self._currentY = State(initialValue: y * screenSize.height)
        // Initialize with the assigned base color
        self._currentColor = State(initialValue: color)
    }
    
    var body: some View {
        ZStack {
            // MARK: - Main Bubble Body
            // Primary bubble circle with radial gradient for spherical appearance
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(opacity * 1.5),  // Bright center highlight
                            currentColor.opacity(opacity * 0.8),   // Current animated color
                            .clear                         // Transparent edges
                        ]),
                        center: .center,                   // Gradient centered in bubble
                        startRadius: 0,                    // Start from center
                        endRadius: size * 0.8              // End before edges for soft look
                    )
                )
                .frame(width: size, height: size)          // Set bubble size
            
            // MARK: - Bubble Highlight/Reflection
            // Small circle for realistic light reflection
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.6),           // Reduced opacity
                            .white.opacity(0.15),          // Reduced opacity
                            .clear                         // Transparent beyond
                        ]),
                        center: UnitPoint(x: 0.3, y: 0.3), // Reflection positioned top-left
                        startRadius: 0,
                        endRadius: size * 0.3              // Smaller reflection
                    )
                )
                .frame(width: size * 0.3, height: size * 0.3) // Smaller reflection
                .offset(x: -size * 0.1, y: -size * 0.1)   // Closer to center
            
            // MARK: - Conservative Shimmer Effect
            // Much more contained shimmer that stays well within bubble bounds
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,                        // Transparent start
                            .white.opacity(0.25),          // Very subtle shimmer
                            .clear                         // Transparent end
                        ],
                        startPoint: .leading,              // Gradient flows left to right
                        endPoint: .trailing
                    )
                )
                .frame(width: size * 0.4, height: size * 0.05) // Much smaller shimmer
                .rotationEffect(.degrees(45))              // Diagonal orientation
                .offset(x: shimmerOffset, y: shimmerOffset * 0.5)
        }
        // Apply all transformations to the ENTIRE bubble group
        .rotationEffect(.degrees(rotation))                // Continuous rotation
        .offset(
            x: (x * screenSize.width - screenSize.width / 2) + xWobble,
            y: currentY - screenSize.height / 2
        )
        .scaleEffect(scale)                                // Pulsing scale animation
        .onAppear {
            startAnimations()  // Start all animations when bubble appears
        }
    }
    
    // MARK: - Animation Control
    // Starts all bubble animations with coordinated timing
    private func startAnimations() {
        // Rising animation - bubbles float upward slowly
        withAnimation(.linear(duration: riseSpeed).repeatForever(autoreverses: false)) {
            currentY = -size  // Move to top of screen (above view)
        }
        
        // Wobble side-to-side - gentle horizontal movement
        withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
            xWobble = CGFloat.random(in: -10...10)  // Further reduced wobble range
        }
        
        // Gentle pulsing scale - subtle size changes
        withAnimation(.easeInOut(duration: speed * 2).repeatForever(autoreverses: true)) {
            scale = CGFloat.random(in: 0.97...1.03)  // Much more subtle pulsing
        }
        
        // Slow rotation - continuous spinning
        withAnimation(.linear(duration: speed * 6).repeatForever(autoreverses: false)) {
            rotation = 360  // Full rotation
        }
        
        // Conservative shimmer movement - very contained
        withAnimation(.linear(duration: speed * 4).repeatForever(autoreverses: false)) {
            shimmerOffset = size * 0.6  // Very short travel distance
        }
        
        // COLOR CHANGING ANIMATION - Cycle through blue, purple, and pink
        withAnimation(.easeInOut(duration: speed * 3).repeatForever(autoreverses: false)) {
            // Create a color sequence: blue → purple → pink → blue
            let colors: [Color] = [.blue, .purple, .pink, .blue]
            if let currentIndex = colors.firstIndex(of: currentColor) {
                let nextIndex = (currentIndex + 1) % colors.count
                currentColor = colors[nextIndex]
            } else {
                currentColor = .blue // Fallback if color not found
            }
        }
        
        // Reset bubble position when it goes off screen for continuous flow
        DispatchQueue.main.asyncAfter(deadline: .now() + riseSpeed) {
            resetBubble()
        }
    }
    
    // MARK: - Bubble Recycling
    // Resets bubble to bottom of screen for continuous animation
    private func resetBubble() {
        currentY = screenSize.height + size  // Position below screen
        // Restart rising animation
        withAnimation(.linear(duration: riseSpeed).repeatForever(autoreverses: false)) {
            currentY = -size  // Rise to top again
        }
        
        // Schedule next reset for infinite loop
        DispatchQueue.main.asyncAfter(deadline: .now() + riseSpeed) {
            resetBubble()
        }
    }
}

// MARK: - Preview
// Preview for Xcode canvas - shows how the bubbles background looks during development
#Preview {
    BubblesBackground()
}

