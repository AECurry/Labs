//
//  TodayTimelineCard.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import SwiftUI

struct TodayTimelineCard: View {
    let sessions: [TodaySession]
    let isHealthKitEnabled: Bool
    
    // Card styling
    private let cornerRadius: CGFloat = 16
    private let cardHeight: CGFloat = 100
    private let padding: CGFloat = 16
    private let strokeWidth: CGFloat = 1
    
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
                    // No sessions today
                    Text("No walks yet today")
                        .font(.custom("Inter-Regular", size: 14))
                        .foregroundColor(MasukiColors.coffeeBean)
                } else {
                    // Timeline visualization
                    TimelineVisualization(sessions: sessions)
                        .padding(.horizontal, padding)
                }
            } else {
                // HealthKit disabled prompt
                VStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(MasukiColors.mediumJungle.opacity(0.5))
                    
                    Text("Enable HealthKit to see your activity timeline")
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, padding)
            }
        }
        .frame(height: cardHeight)
    }
}

struct TimelineVisualization: View {
    let sessions: [TodaySession]
    
    private let barHeight: CGFloat = 40
    private let barWidth: CGFloat = 8
    private let barSpacing: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background timeline (dashed line)
                HStack(spacing: 0) {
                    Text("12 AM")
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .foregroundColor(MasukiColors.adaptiveText.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("12 AM")
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(MasukiColors.adaptiveText)
                }
                
                // Session bars (positioned based on time)
                ForEach(Array(sessions.prefix(3).enumerated()), id: \.element.id) { index, session in
                    SessionBar(session: session)
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
        
        // Reserve space for labels (approximately 50pt on each side)
        let usableWidth = width - 100
        let position = (totalMinutes / dayMinutes) * usableWidth + 50
        
        return position
    }
}

struct SessionBar: View {
    let session: TodaySession
    
    private let barWidth: CGFloat = 8
    private let totalBars: Int = 3
    private let barSpacing: CGFloat = 2
    
    var body: some View {
        HStack(spacing: barSpacing) {
            ForEach(0..<totalBars, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 4)
                    .fill(MasukiColors.mediumJungle)
                    .frame(width: barWidth, height: 40)
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
            sessions: [
                TodaySession(
                    startTime: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!,
                    endTime: Calendar.current.date(bySettingHour: 9, minute: 3, second: 0, of: Date())!,
                    duration: 33 * 60,
                    distance: 4.2,
                    calories: 1058
                )
            ],
            isHealthKitEnabled: true
        )
        
        // No sessions
        TodayTimelineCard(
            sessions: [],
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
