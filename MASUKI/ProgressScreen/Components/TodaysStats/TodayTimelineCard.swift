//
//  TodayTimelineCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodayTimelineCard: View {
    let sessions: [TodaySession]  // ← Make sure this is declared
    let isHealthKitEnabled: Bool  // ← Make sure this is declared
    
    // MARK: - Design Constants
    private let cardWidth: CGFloat = 360          // Card width
    private let cornerRadius: CGFloat = 16        // Rounded corners
    private let strokeWidth: CGFloat = 2          // Border thickness
    
    // Spacing
    private let padding: CGFloat = 16             // Card padding
    private let cardHeight: CGFloat = 100         // Fixed card height
    private let messageSpacing: CGFloat = 8       // Space in HealthKit message
    
    // Typography
    private let noSessionsFontSize: CGFloat = 14  // "No walks yet today"
    private let messageFontSize: CGFloat = 12     // HealthKit prompt text
    
    // Timeline Visualization
    private let timelineBarHeight: CGFloat = 40
    private let timelineBarWidth: CGFloat = 8
    private let timelineBarSpacing: CGFloat = 4
    private let maxSessionsDisplayed: Int = 3     // Max sessions to show
    
    // HealthKit Icon
    private let iconSize: CGFloat = 20            // Heart icon size
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(MasukiColors.adaptiveBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(MasukiColors.mediumJungle.opacity(0.2), lineWidth: strokeWidth)
                )
            
            if isHealthKitEnabled {
                if sessions.isEmpty {
                    // No sessions today - CENTERED
                    Text("No walks yet today")
                        .font(.custom("Inter-Regular", size: noSessionsFontSize))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // ← ADD THIS
                } else {
                    // Timeline visualization
                    TimelineVisualization(
                        sessions: sessions,  // ← Pass sessions here
                        barHeight: timelineBarHeight,
                        barWidth: timelineBarWidth,
                        barSpacing: timelineBarSpacing,
                        maxSessionsDisplayed: maxSessionsDisplayed
                    )
                    .padding(.horizontal, padding)
                }
            } else {
                // HealthKit disabled prompt - CENTERED
                VStack(spacing: messageSpacing) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: iconSize))
                        .foregroundColor(MasukiColors.mediumJungle.opacity(0.5))
                    
                    Text("Enable HealthKit to see your activity timeline")
                        .font(.custom("Inter-Regular", size: messageFontSize))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ← ADD THIS
                .padding(.horizontal, padding)
            }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

struct TimelineVisualization: View {
    let sessions: [TodaySession]
    let barHeight: CGFloat
    let barWidth: CGFloat
    let barSpacing: CGFloat
    let maxSessionsDisplayed: Int
    
    // Timeline labels
    private let labelFontSize: CGFloat = 12
    private let labelPadding: CGFloat = 50        // Space for labels on each side
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background timeline (dashed line)
                HStack(spacing: 0) {
                    Text("12 AM")
                        .font(.custom("Inter-Regular", size: labelFontSize))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .foregroundColor(MasukiColors.adaptiveText.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("12 AM")
                        .font(.custom("Inter-Regular", size: labelFontSize))
                        .foregroundColor(MasukiColors.adaptiveText)
                }
                
                // Session bars (positioned based on time)
                ForEach(Array(sessions.prefix(maxSessionsDisplayed).enumerated()), id: \.element.id) { index, session in
                    SessionBar(
                        barWidth: barWidth,
                        barHeight: barHeight,
                        barSpacing: barSpacing
                    )
                    .position(
                        x: calculateXPosition(for: session, in: geometry.size.width),
                        y: geometry.size.height / 2
                    )
                }
            }
        }
    }
    
    private func calculateXPosition(for session: TodaySession, in width: CGFloat) -> CGFloat {
        let hour = Calendar.current.component(.hour, from: session.startTime)
        let minute = Calendar.current.component(.minute, from: session.startTime)
        let totalMinutes = Double(hour * 60 + minute)
        let dayMinutes = 24.0 * 60.0
        
        // Reserve space for labels
        let usableWidth = width - (labelPadding * 2)
        let position = (totalMinutes / dayMinutes) * usableWidth + labelPadding
        
        return position
    }
}

struct SessionBar: View {
    let barWidth: CGFloat
    let barHeight: CGFloat
    let barSpacing: CGFloat
    
    private let totalBars: Int = 3  // Fixed number of bars per session
    
    var body: some View {
        HStack(spacing: barSpacing) {
            ForEach(0..<totalBars, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(MasukiColors.mediumJungle)
                    .frame(width: barWidth, height: barHeight)
            }
        }
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        // With sessions
        TodayTimelineCard(
            sessions: [  // ← MAKE SURE this parameter is named
                TodaySession(
                    id: UUID(),
                    startTime: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!,
                    endTime: Calendar.current.date(bySettingHour: 9, minute: 3, second: 0, of: Date())!,
                    duration: 33 * 60,
                    distance: 4.2,
                    calories: 1058
                )
            ],
            isHealthKitEnabled: true  // ← MAKE SURE this parameter is named
        )
        
        // No sessions
        TodayTimelineCard(
            sessions: [],  // ← Empty array
            isHealthKitEnabled: true
        )
        
        // HealthKit disabled
        TodayTimelineCard(
            sessions: [],
            isHealthKitEnabled: false
        )
    }
    .padding()
    .background(MasukiColors.adaptiveBackground)
}

