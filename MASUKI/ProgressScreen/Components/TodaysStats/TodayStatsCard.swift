//
//  TodayStatsCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodayStatsCard: View {
    // MARK: - Properties
    let activeTime: TimeInterval
    let calories: Double
    let miles: Double
    let isHealthKitEnabled: Bool
    let useMetric: Bool
    
    // MARK: - Design Constants
    private let cardWidth: CGFloat = 360          // Card width
    private let cornerRadius: CGFloat = 16        // Rounded corners
    private let strokeWidth: CGFloat = 2          // Border thickness
    
    // Spacing
    private let topPadding: CGFloat = 24          // Space above "Active Time"
    private let sidePadding: CGFloat = 16         // Left/right margins
    private let bottomPadding: CGFloat = 16       // Space below message
    private let titleValueSpacing: CGFloat = 8    // Gap between title and value
    private let messageTopSpacing: CGFloat = 16   // Space above HealthKit message
    
    // Typography
    private let titleFontSize: CGFloat = 14       // "Active Time", "Calories", "Miles"
    private let valueFontSize: CGFloat = 28       // "0 mins", "1058", "4.2"
    private let messageFontSize: CGFloat = 12     // HealthKit prompt text
    
    // Dividers
    private let dividerWidth: CGFloat = 1         // Width of divider line
    private let dividerHeight: CGFloat = 64       // Height of divider line
    private let dividerSpacing: CGFloat = 12       // ← FIXED: Space on BOTH sides of divider
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Stats row
            statsContent
                .padding(.horizontal, sidePadding)
                .padding(.top, topPadding)
            
            // HealthKit message or spacing
            if !isHealthKitEnabled {
                healthKitMessage
            } else {
                Spacer(minLength: 0)
                    .padding(.bottom, bottomPadding)
            }
        }
        .frame(width: cardWidth)
        .background(MasukiColors.adaptiveBackground.opacity(0.5))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(MasukiColors.mediumJungle.opacity(0.2), lineWidth: strokeWidth)
        )
    }
    
    // MARK: - Private Views
    
    /// Horizontal stack containing the three statistics columns separated by dividers
    /// Each divider has symmetric spacing on both sides controlled by `dividerSpacing`
    private var statsContent: some View {
        HStack(spacing: 0) {
            // Column 1: Active Time
            StatColumn(
                title: "Active Time",
                value: formatTime(activeTime),
                isEnabled: true,
                titleSize: titleFontSize,
                valueSize: valueFontSize,
                spacing: titleValueSpacing,
                height: dividerHeight
            )
            
            // Divider 1 with spacing
            Divider()
                .frame(width: dividerWidth, height: dividerHeight)
                .background(MasukiColors.adaptiveText.opacity(0.2))
                .padding(.horizontal, dividerSpacing)  // ← Symmetric spacing on both sides
            
            // Column 2: Calories
            StatColumn(
                title: "Calories",
                value: isHealthKitEnabled ? formatCalories(calories) : "---",
                isEnabled: isHealthKitEnabled,
                titleSize: titleFontSize,
                valueSize: valueFontSize,
                spacing: titleValueSpacing,
                height: dividerHeight
            )
            
            // Divider 2 with spacing
            Divider()
                .frame(width: dividerWidth, height: dividerHeight)
                .background(MasukiColors.adaptiveText.opacity(0.2))
                .padding(.horizontal, dividerSpacing)  // ← Symmetric spacing on both sides
            
            // Column 3: Distance (Miles/Kilometers)
            StatColumn(
                title: useMetric ? "Kilometers" : "Miles",
                value: isHealthKitEnabled ? formatDistance(miles) : "---",
                isEnabled: isHealthKitEnabled,
                titleSize: titleFontSize,
                valueSize: valueFontSize,
                spacing: titleValueSpacing,
                height: dividerHeight
            )
        }
    }
    
    /// Message prompting user to enable HealthKit
    /// Only shown when `isHealthKitEnabled` is false
    private var healthKitMessage: some View {
        VStack(spacing: messageTopSpacing) {
            Spacer(minLength: 0)
            
            Text("Enable HealthKit for calories & distance")
                .font(.custom("Inter-Regular", size: messageFontSize))
                .foregroundColor(MasukiColors.coffeeBean.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, bottomPadding)
                .padding(.horizontal, sidePadding)
        }
    }
    
    // MARK: - Formatting Methods
    
    /// Formats a TimeInterval into a minutes string
    /// - Parameter interval: Time in seconds
    /// - Returns: Formatted string like "33 mins"
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = max(0, Int(interval / 60))
        return "\(minutes) mins"
    }
    
    /// Formats calories value into a string
    /// - Parameter value: Calories as Double
    /// - Returns: Integer string of calories
    private func formatCalories(_ value: Double) -> String {
        let safeValue = max(0, value)
        return "\(Int(safeValue))"
    }
    
    /// Formats distance value into miles or kilometers
    /// - Parameter value: Distance in miles
    /// - Returns: Formatted string with 1 decimal place
    private func formatDistance(_ value: Double) -> String {
        let safeValue = max(0, value)
        if useMetric {
            // Convert miles to kilometers
            return String(format: "%.1f", safeValue * 1.60934)
        }
        return String(format: "%.1f", safeValue)
    }
}

// MARK: - Stat Column Component

/// Reusable component for displaying a statistic title and value
private struct StatColumn: View {
    let title: String
    let value: String
    let isEnabled: Bool
    let titleSize: CGFloat
    let valueSize: CGFloat
    let spacing: CGFloat
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: spacing) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: titleSize))
                .foregroundColor(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(value)
                .font(.custom("Inter-SemiBold", size: valueSize))
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: height)
    }
    
    /// Returns the appropriate text color based on enabled state
    private var textColor: Color {
        isEnabled ? MasukiColors.adaptiveText :
                   MasukiColors.adaptiveText.opacity(0.3)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        // HealthKit enabled - Imperial units
        TodayStatsCard(
            activeTime: 33 * 60,
            calories: 1058,
            miles: 4.2,
            isHealthKitEnabled: true,
            useMetric: false
        )
        
        // HealthKit disabled
        TodayStatsCard(
            activeTime: 33 * 60,
            calories: 0,
            miles: 0,
            isHealthKitEnabled: false,
            useMetric: false
        )
        
        // HealthKit enabled - Metric units
        TodayStatsCard(
            activeTime: 33 * 60,
            calories: 1058,
            miles: 4.2,
            isHealthKitEnabled: true,
            useMetric: true
        )
    }
    .padding()
    .background(MasukiColors.adaptiveBackground)
}
