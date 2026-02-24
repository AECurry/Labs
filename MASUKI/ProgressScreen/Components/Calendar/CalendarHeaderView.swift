//
//  CalendarHeaderView.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import SwiftUI

struct CalendarHeaderView: View {
    let monthYear: String
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onTodayTap: () -> Void
    
    // MARK: - Design Constants
    private let headerHeight: CGFloat = 60
    private let buttonSize: CGFloat = 44
    private let titleFontSize: CGFloat = 20
    private let iconSize: CGFloat = 20
    
    var body: some View {
        HStack {
            // Previous month button
            Button(action: onPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .frame(width: buttonSize, height: buttonSize)
            }
            
            Spacer()
            
            // Month/Year title
            Text(monthYear)
                .font(.custom("Spinnaker-Regular", size: titleFontSize))
                .foregroundColor(MasukiColors.adaptiveText)
            
            Spacer()
            
            // Next month button
            Button(action: onNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .frame(width: buttonSize, height: buttonSize)
            }
        }
        .frame(height: headerHeight)
        .padding(.horizontal, 16)
        
        // "Today" button (optional - shows below header)
        Button(action: onTodayTap) {
            Text("Today")
                .font(.custom("Inter-SemiBold", size: 14))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(MasukiColors.mediumJungle)
                .cornerRadius(20)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    CalendarHeaderView(
        monthYear: "February 2026",
        onPreviousMonth: { print("Previous") },
        onNextMonth: { print("Next") },
        onTodayTap: { print("Today") }
    )
    .background(MasukiColors.adaptiveBackground)
}

