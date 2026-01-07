//
//  ProgressBadgeArea.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ProgressBadgeArea: View {
    // MARK: - Badge Display Configuration
    @AppStorage("progressBadgeTopPadding") private var topPadding: Double = 0
    @AppStorage("progressBadgeBottomPadding") private var bottomPadding: Double = 24
    @AppStorage("progressBadgeHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("progressBadgeWidth") private var width: Double = 200
    @AppStorage("progressBadgeHeight") private var height: Double = 200
    @AppStorage("progressBadgeCornerRadius") private var cornerRadius: Double = 100 // Circle
    @AppStorage("progressBadgeShadowRadius") private var shadowRadius: Double = 12
    @AppStorage("progressBadgeShadowOpacity") private var shadowOpacity: Double = 0.15
    
    // MARK: - Animation State
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    // MARK: - Badge Data
    let badge: AchievementBadge
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .fill(MasukiColors.mediumJungle.opacity(0.1))
                .frame(width: width, height: height)
            
            // Badge Icon (Large Display)
            Image(systemName: badge.iconName)
                .font(.system(size: 80))
                .foregroundColor(badge.isUnlocked ?
                    MasukiColors.mediumJungle :
                    Color.gray.opacity(0.3))
                .scaleEffect(scale)
                .rotationEffect(.degrees(rotation))
            
            // Achievement Status Indicator
            if badge.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(MasukiColors.mediumJungle)
                    .background(Circle().fill(Color.white).frame(width: 28, height: 28))
                    .offset(x: width * 0.35, y: -height * 0.35)
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: shadowRadius,
            x: 0,
            y: 4
        )
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
        .onAppear {
            if badge.isUnlocked {
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // Gentle rotation animation (slower than other screens for badges)
        withAnimation(
            .linear(duration: 25)
                .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
        
        // Gentle pulsing scale animation
        withAnimation(
            .easeInOut(duration: 2.5)
                .repeatForever(autoreverses: true)
        ) {
            scale = 1.15
        }
    }
}
