//
//  TodayStatsCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

// MARK: - Configuration Constants
private enum CardConfig {
    // Dimensions
    static let cornerRadius: CGFloat = 16
    static let strokeWidth: CGFloat = 1
    static let fixedWidth: CGFloat = 360
    
    // Spacing
    static let contentPadding: EdgeInsets = .init(top: 24, leading: 16, bottom: 16, trailing: 16)
    static let columnSpacing: CGFloat = 0
    static let titleValueSpacing: CGFloat = 8
    
    // Dividers
    static let dividerWidth: CGFloat = 1
    static let dividerOpacity: CGFloat = 0.2
    static let dividerHeight: CGFloat = 64
    
    // Fonts
    static let titleFontSize: CGFloat = 14
    static let valueFontSize: CGFloat = 28
    static let messageFontSize: CGFloat = 12
    
    // Colors
    static let disabledOpacity: CGFloat = 0.3
    static let backgroundOpacity: CGFloat = 0.5
}

// MARK: - Main View
struct TodayStatsCard: View {
    // MARK: - Properties
    let activeTime: TimeInterval
    let calories: Double
    let miles: Double
    let isHealthKitEnabled: Bool
    let useMetric: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            statsContent
                .padding(.horizontal, CardConfig.contentPadding.leading)
                .padding(.top, CardConfig.contentPadding.top)
            
            if !isHealthKitEnabled {
                healthKitMessage
            } else {
                Spacer(minLength: 0)
                    .padding(.bottom, CardConfig.contentPadding.bottom)
            }
        }
        .frame(width: CardConfig.fixedWidth)
        .background(MasukiColors.adaptiveBackground.opacity(CardConfig.backgroundOpacity))
        .cornerRadius(CardConfig.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: CardConfig.cornerRadius)
                .stroke(MasukiColors.mediumJungle.opacity(CardConfig.dividerOpacity),
                       lineWidth: CardConfig.strokeWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Private Views
    private var statsContent: some View {
        HStack(spacing: CardConfig.columnSpacing) {
            StatColumn(
                title: "Active Time",
                value: formatTime(activeTime),
                isEnabled: true
            )
            
            CustomDivider()
            
            StatColumn(
                title: "Calories",
                value: isHealthKitEnabled ? formatCalories(calories) : "---",
                isEnabled: isHealthKitEnabled
            )
            
            CustomDivider()
            
            StatColumn(
                title: useMetric ? "Kilometers" : "Miles",
                value: isHealthKitEnabled ? formatDistance(miles) : "---",
                isEnabled: isHealthKitEnabled
            )
        }
    }
    
    private var healthKitMessage: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 0)
            
            Text("Enable HealthKit for calories & distance")
                .font(.custom("Inter-Regular", size: CardConfig.messageFontSize))
                .foregroundColor(MasukiColors.coffeeBean.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.bottom, CardConfig.contentPadding.bottom)
                .padding(.horizontal, CardConfig.contentPadding.leading)
                .accessibilityLabel("Enable HealthKit to view calories and distance data")
        }
    }
    
    // MARK: - Formatting Methods
    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = max(0, Int(interval / 60))
        return "\(minutes) mins"
    }
    
    private func formatCalories(_ value: Double) -> String {
        let safeValue = max(0, value)
        return "\(Int(safeValue))"
    }
    
    private func formatDistance(_ value: Double) -> String {
        let safeValue = max(0, value)
        
        if useMetric {
            let kilometers = safeValue * 1.60934
            return String(format: "%.1f", kilometers)
        }
        
        return String(format: "%.1f", safeValue)
    }
    
    // MARK: - Accessibility
    private var accessibilityLabel: String {
        var label = "Active Time: \(formatTime(activeTime))"
        
        if isHealthKitEnabled {
            label += ", Calories: \(formatCalories(calories))"
            label += ", \(useMetric ? "Kilometers" : "Miles"): \(formatDistance(miles))"
        } else {
            label += ", HealthKit disabled for calories and distance"
        }
        
        return label
    }
}

// MARK: - Stat Column Component
private struct StatColumn: View {
    let title: String
    let value: String
    let isEnabled: Bool
    
    var body: some View {
        VStack(spacing: CardConfig.titleValueSpacing) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: CardConfig.titleFontSize))
                .foregroundColor(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .accessibilityLabel("\(title): \(value)")
            
            Text(value)
                .font(.custom("Inter-SemiBold", size: CardConfig.valueFontSize))
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: CardConfig.dividerHeight)
    }
    
    private var textColor: Color {
        isEnabled ? MasukiColors.adaptiveText :
                   MasukiColors.adaptiveText.opacity(CardConfig.disabledOpacity)
    }
}

// MARK: - Divider Component
private struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .fill(MasukiColors.adaptiveText.opacity(CardConfig.dividerOpacity))
            .frame(width: CardConfig.dividerWidth,
                   height: CardConfig.dividerHeight)
            .frame(maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        // HealthKit enabled - Imperial
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
        
        // HealthKit enabled - Metric
        TodayStatsCard(
            activeTime: 33 * 60,
            calories: 1058,
            miles: 4.2,
            isHealthKitEnabled: true,
            useMetric: true
        )
        
        // Edge cases
        TodayStatsCard(
            activeTime: 0,
            calories: -100,
            miles: -5,
            isHealthKitEnabled: true,
            useMetric: false
        )
    }
    .padding()
    .background(MasukiColors.adaptiveBackground)
}
