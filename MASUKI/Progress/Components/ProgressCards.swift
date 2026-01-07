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
    
    var body: some View {
        Text(String(format: "%.0f", displayedValue))
            .font(.custom("Spinnaker-Regular", size: 64))
            .foregroundColor(MasukiColors.mediumJungle)
            .contentTransition(.numericText())
            .onChange(of: value) { oldValue, newValue in
                withAnimation(.spring(duration: 0.8)) {
                    displayedValue = newValue
                }
            }
            .onAppear { displayedValue = value }
    }
}

struct TodayProgressCard: View {
    let miles: Double
    
    // Explicit initializer to avoid ambiguity
    init(miles: Double) {
        self.miles = miles
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
        .padding()
        .background(MasukiColors.adaptiveBackground.opacity(0.5))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(MasukiColors.mediumJungle.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(), value: isAnimating)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(currentStreak) day streak")
                    .font(.custom("Spinnaker-Regular", size: 18))
                    .foregroundColor(MasukiColors.adaptiveText)
                Text("Longest: \(longestStreak) days")
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundColor(MasukiColors.adaptiveText.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(MasukiColors.adaptiveBackground.opacity(0.5))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
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
