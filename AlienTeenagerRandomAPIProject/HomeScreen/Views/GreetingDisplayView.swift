//
//  GreetingDisplayView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/20/25.
//

import SwiftUI

struct GreetingDisplayView: View {
    @State private var currentGreetingIndex = 0
    @State private var isVisible = true
    @State private var timer: Timer?
    
    private var currentGreeting: AlienGreeting {
        AlienGreeting.allGreetings[currentGreetingIndex]
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 116)
            
            // Clean Globe with Text Layout
            GlobeTextLayout(
                topText: currentGreeting.topText,
                bottomText: currentGreeting.bottomText,
                bottomTextColor: currentGreeting.color
            )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.8), value: isVisible)
        .onAppear { startLanguageRotation() }
        .onDisappear { timer?.invalidate() }
    }
    
    private func startLanguageRotation() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.4)) {
                isVisible = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                currentGreetingIndex = (currentGreetingIndex + 1) % AlienGreeting.allGreetings.count
                
                withAnimation(.easeInOut(duration: 0.4)) {
                    isVisible = true
                }
            }
        }
    }
}

struct GlobeTextLayout: View {
    let topText: String
    let bottomText: String
    let bottomTextColor: Color
    
    // Simple, clear parameters
    private let globeSize: CGFloat = 200
    private let topToGlobeSpacing: CGFloat = 16  // Space between Globe and top text
    private let globeToBottomSpacing: CGFloat = 16 // Space between Globe and bottom text
    
    var body: some View {
        VStack(spacing: 0) {
            Text(topText)
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, topToGlobeSpacing) // Clear purpose
            
            Image(systemName: "globe")
                .font(.system(size: globeSize))
                .foregroundStyle(.white)
                .shadow(color: .cyan.opacity(0.9), radius: 30, x: 0, y: 0) // Strong cyan glow
                .shadow(color: .blue.opacity(0.6), radius: 15, x: 0, y: 0) // Blue halo
                .overlay(
                    Image(systemName: "globe")
                        .font(.system(size: globeSize))
                        .foregroundStyle(.black.opacity(0.3))
                        .blur(radius: 3)
                        .offset(x: 3, y: 3)
                        .mask(
                            Image(systemName: "globe")
                                .font(.system(size: globeSize))
                        )
                )
                .padding(.bottom, globeToBottomSpacing)
            
            Text(bottomText)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(bottomTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.deepNavy.ignoresSafeArea()
        GreetingDisplayView()
    }
}
