//
//  CalendarDayCell.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import SwiftUI

struct CalendarDayCell: View {
    let date: Date?
    let isSelected: Bool
    let isToday: Bool
    let hasData: Bool
    let onTap: () -> Void
    
    // MARK: - Design Constants
    private let cellSize: CGFloat = 44
    private let dayFontSize: CGFloat = 16
    private let dotSize: CGFloat = 6
    private let selectedBorderWidth: CGFloat = 2
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Background circle for selected/today
                if isSelected {
                    Circle()
                        .fill(MasukiColors.mediumJungle.opacity(0.2))
                        .overlay(
                            Circle()
                                .stroke(MasukiColors.mediumJungle, lineWidth: selectedBorderWidth)
                        )
                } else if isToday {
                    Circle()
                        .stroke(MasukiColors.mediumJungle.opacity(0.5), lineWidth: 1)
                }
                
                // Day number
                if let date = date {
                    VStack(spacing: 2) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.custom("Inter-SemiBold", size: dayFontSize))
                            .foregroundColor(textColor)
                        
                        // Green dot indicator for days with data
                        if hasData {
                            Circle()
                                .fill(MasukiColors.mediumJungle)
                                .frame(width: dotSize, height: dotSize)
                        } else {
                            // Invisible spacer to maintain alignment
                            Circle()
                                .fill(Color.clear)
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                }
            }
            .frame(width: cellSize, height: cellSize)
        }
        .buttonStyle(.plain)
        .disabled(date == nil)
    }
    
    private var textColor: Color {
        if date == nil {
            return Color.clear
        }
        if isSelected {
            return MasukiColors.mediumJungle
        }
        return MasukiColors.adaptiveText
    }
}

#Preview {
    HStack(spacing: 8) {
        // Empty cell
        CalendarDayCell(
            date: nil,
            isSelected: false,
            isToday: false,
            hasData: false,
            onTap: {}
        )
        
        // Regular day
        CalendarDayCell(
            date: Date(),
            isSelected: false,
            isToday: false,
            hasData: false,
            onTap: {}
        )
        
        // Day with data
        CalendarDayCell(
            date: Date(),
            isSelected: false,
            isToday: false,
            hasData: true,
            onTap: {}
        )
        
        // Today
        CalendarDayCell(
            date: Date(),
            isSelected: false,
            isToday: true,
            hasData: true,
            onTap: {}
        )
        
        // Selected
        CalendarDayCell(
            date: Date(),
            isSelected: true,
            isToday: false,
            hasData: true,
            onTap: {}
        )
    }
    .padding()
    .background(MasukiColors.adaptiveBackground)
}
