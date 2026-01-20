//
//  ProgressCards.swift
//  MASUKI
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct AnimatedMilesCounter: View {
    let value: Double
    @State private var displayedValue: Double = 0
    
    // Component styling
    private let fontSize: CGFloat = 64
    private let animationDuration: Double = 0.8
    
    var body: some View {
        Text(String(format: "%.0f", displayedValue))
            .font(.custom("Spinnaker-Regular", size: fontSize))
            .foregroundColor(MasukiColors.mediumJungle)
            .contentTransition(.numericText())
            .onChange(of: value) { oldValue, newValue in
                withAnimation(.spring(duration: animationDuration)) {
                    displayedValue = newValue
                }
            }
            .onAppear { displayedValue = value }
    }
}

struct TodayProgressCard: View {
    let miles: Double
    
    // Card styling
    private let cornerRadius: CGFloat = 16
    private let contentSpacing: CGFloat = 12
    private let strokeWidth: CGFloat = 1
    private let padding: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: contentSpacing) {
            HStack {
                Text("Today")
                    .font(.custom("Spinnaker-Regular", size: 20))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Spacer()
                
                ProgressRing(progress: miles / 5.0)
            }
            
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(MasukiColors.mediumJungle)
                
                Text(String(format: "%.1f miles", miles))
                    .font(.custom("Inter-Regular", size: 24))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Spacer()
            }
        }
        .padding(padding)
        .background(MasukiColors.adaptiveBackground.opacity(0.5))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(MasukiColors.mediumJungle.opacity(0.2), lineWidth: strokeWidth)
        )
    }
}

struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    @State private var isAnimating = false
    
    // Card styling
    private let cornerRadius: CGFloat = 16
    private let contentSpacing: CGFloat = 4
    private let strokeWidth: CGFloat = 1
    private let padding: CGFloat = 16
    private let animationDuration: Double = 0.6
    
    var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: animationDuration).repeatForever(), value: isAnimating)
            
            VStack(alignment: .leading, spacing: contentSpacing) {
                Text("\(currentStreak) day streak")
                    .font(.custom("Spinnaker-Regular", size: 18))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Text("Longest: \(longestStreak) days")
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundColor(MasukiColors.adaptiveText.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(padding)
        .background(MasukiColors.adaptiveBackground.opacity(0.5))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.orange.opacity(0.2), lineWidth: strokeWidth)
        )
        .onAppear { isAnimating = true }
    }
}

struct ProgressRing: View {
    let progress: Double
    var size: CGFloat = 40
    var lineWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(MasukiColors.mediumJungle.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(MasukiColors.mediumJungle, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.custom("Inter-Regular", size: 10))
                .foregroundColor(MasukiColors.adaptiveText)
        }
    }
}
