//
//  AnimatedGridBackground.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/12/25.
//

import SwiftUI

struct AnimatedGridBackground: View {
    // ═══════════════════════════════════════════════════════════
    // CUSTOMIZATION PARAMETERS - CHANGE THESE TO ADJUST THE EFFECT
    // ═══════════════════════════════════════════════════════════
    
    // Grid settings
    let gridSpacing: CGFloat = 40              // Distance between grid lines (pixels)
    let gridLineThickness: CGFloat = 0.5         // Base grid line width (pixels)
    let gridLineColor: Color = .white.opacity(0.15)  // Static grid line color
    
    // Pulse settings
    let pulseThickness: CGFloat = 3            // Glowing pulse width (pixels)
    let pulseColor: Color = .fnRed              // Pulse color (cyan tech glow)
    let pulseGlowRadius: CGFloat = 8           // Blur radius for glow effect
    let pulseSpeed: Double = 4                 // Seconds to travel across screen
    let simultaneousPulses: Int = 2            // How many pulses at once (1 or 2)
    let timeBetweenPulses: Double = 4          // Seconds between new pulses
    
    // State for tracking active pulses
    @State private var activePulses: [GridPulse] = []
    
    var body: some View {
        ZStack {
            // Background: DARKER purple radial gradient
            RadialGradient(
                colors: [
                    Color(red: 0.08, green: 0.0, blue: 0.15),  // Much darker purple (center)
                    Color(red: 0.15, green: 0.0, blue: 0.25),  // Dark purple
                    Color(red: 0.20, green: 0.05, blue: 0.35), // Medium purple
                    Color(red: 0.15, green: 0.0, blue: 0.25),  // Dark purple
                    Color(red: 0.05, green: 0.0, blue: 0.10)   // Very dark purple (edges)
                ],
                center: .center,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            // Static grid overlay
            GeometryReader { geometry in
                StaticGrid(
                    spacing: gridSpacing,
                    lineThickness: gridLineThickness,
                    lineColor: gridLineColor,
                    screenSize: geometry.size
                )
                
                // Animated pulses
                ForEach(activePulses) { pulse in
                    AnimatedPulse(
                        pulse: pulse,
                        thickness: pulseThickness,
                        color: pulseColor,
                        glowRadius: pulseGlowRadius,
                        speed: pulseSpeed,
                        screenSize: geometry.size
                    )
                }
            }
        }
        .onAppear {
            startPulseGenerator()
        }
    }
    
    // Generate new pulses at intervals
    private func startPulseGenerator() {
        Timer.scheduledTimer(withTimeInterval: timeBetweenPulses, repeats: true) { _ in
            // Create 1 or 2 simultaneous pulses
            for _ in 0..<simultaneousPulses {
                let newPulse = GridPulse.random(spacing: gridSpacing)
                activePulses.append(newPulse)
                
                // Remove pulse after animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + pulseSpeed + 0.5) {
                    activePulses.removeAll { $0.id == newPulse.id }
                }
            }
        }
        
        // Create initial pulse immediately
        let initialPulse = GridPulse.random(spacing: gridSpacing)
        activePulses.append(initialPulse)
    }
}

// MARK: - Grid Pulse Data Model
struct GridPulse: Identifiable {
    let id = UUID()
    let direction: Direction      // Which way the pulse travels
    let lineIndex: Int            // Which grid line (horizontal or vertical)
    
    enum Direction {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    static func random(spacing: CGFloat) -> GridPulse {
        let directions: [Direction] = [.leftToRight, .rightToLeft, .topToBottom, .bottomToTop]
        let randomDirection = directions.randomElement()!
        let randomLine = Int.random(in: 0...30)  // Grid lines 0-30
        
        return GridPulse(direction: randomDirection, lineIndex: randomLine)
    }
}

// MARK: - Static Grid Lines
struct StaticGrid: View {
    let spacing: CGFloat
    let lineThickness: CGFloat
    let lineColor: Color
    let screenSize: CGSize
    
    var body: some View {
        ZStack {
            // Horizontal lines - start from 0
            ForEach(0..<Int(screenSize.height / spacing) + 2, id: \.self) { i in
                Rectangle()
                    .fill(lineColor)
                    .frame(width: screenSize.width, height: lineThickness)
                    .position(x: screenSize.width / 2, y: CGFloat(i) * spacing)
            }
            
            // Vertical lines - start from 0
            ForEach(0..<Int(screenSize.width / spacing) + 2, id: \.self) { i in
                Rectangle()
                    .fill(lineColor)
                    .frame(width: lineThickness, height: screenSize.height)
                    .position(x: CGFloat(i) * spacing, y: screenSize.height / 2)
            }
        }
    }
}

// MARK: - Animated Pulse
struct AnimatedPulse: View {
    let pulse: GridPulse
    let thickness: CGFloat
    let color: Color
    let glowRadius: CGFloat
    let speed: Double
    let screenSize: CGSize
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        Group {
            switch pulse.direction {
            case .leftToRight, .rightToLeft:
                horizontalPulse
            case .topToBottom, .bottomToTop:
                verticalPulse
            }
        }
        .onAppear {
            withAnimation(.linear(duration: speed)) {
                progress = 1.0
            }
        }
    }
    
    private var horizontalPulse: some View {
        let yPosition = CGFloat(pulse.lineIndex) * 32
        let startX = pulse.direction == .leftToRight ? 0 : screenSize.width
        let endX = pulse.direction == .leftToRight ? screenSize.width : 0
        let currentX = startX + (endX - startX) * progress
        
        return Rectangle()
            .fill(color)
            .frame(width: 40, height: thickness)
            .position(x: currentX, y: yPosition)
            .blur(radius: glowRadius)
            .shadow(color: color, radius: glowRadius * 2)
    }
    
    private var verticalPulse: some View {
        let xPosition = CGFloat(pulse.lineIndex) * 32
        let startY = pulse.direction == .topToBottom ? 0 : screenSize.height
        let endY = pulse.direction == .topToBottom ? screenSize.height : 0
        let currentY = startY + (endY - startY) * progress
        
        return Rectangle()
            .fill(color)
            .frame(width: thickness, height: 40)
            .position(x: xPosition, y: currentY)
            .blur(radius: glowRadius)
            .shadow(color: color, radius: glowRadius * 2)
    }
}

// MARK: - Preview
#Preview("Animated Grid") {
    AnimatedGridBackground()
}

#Preview("With UI Content") {
    ZStack {
        AnimatedGridBackground()
        
        VStack(spacing: 30) {
            Text("Tournaments")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .cyan, radius: 10)
            
            // Sample card
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.5))
                .frame(width: 320, height: 200)
                .overlay(
                    Text("Tournament Card")
                        .foregroundColor(.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.fnGold.opacity(0.2), lineWidth: 3)
                )
        }
    }
}
