//
//  DiscoverGreetingView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/20/25.
//

import SwiftUI

struct DiscoverGreetingView: View {
    @State private var currentGreetingIndex = 0
    @State private var isVisible = true
    @State private var timer: Timer?
    
    private var currentGreeting: AlienGreeting {
        AlienGreeting.allGreetings[currentGreetingIndex]
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(currentGreeting.topText)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            
            Text(currentGreeting.bottomText)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.cyan)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
        }
        .padding(.top, 40)
        .padding(.bottom, 30)
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.4), value: isVisible)
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

#Preview {
    ZStack {
        CustomGradientBkg2()
        DiscoverGreetingView()
    }
}
