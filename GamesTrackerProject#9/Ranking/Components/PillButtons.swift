//
//  PillButtons.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

struct TimeframePill: View {
    let timeframe: RankingTimeframe
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(timeframe.rawValue)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .fnWhite : .fnGray1)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if isSelected {
                            Capsule()
                                .fill(Color.fnBlue.opacity(0.3))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.fnBlue, lineWidth: 2)
                                )
                        } else {
                            Capsule()
                                .fill(Color.fnGray3.opacity(0.1))
                        }
                    }
                )
        }
    }
}

struct ModePill: View {
    let mode: RankingMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: mode.iconName)
                    .font(.caption2)
                
                Text(mode.rawValue)
                    .font(.subheadline)
            }
            .fontWeight(isSelected ? .bold : .medium)
            .foregroundColor(isSelected ? .fnWhite : .fnGray1)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        Capsule()
                            .fill(modeBackgroundColor.opacity(0.3))
                            .overlay(
                                Capsule()
                                    .stroke(modeBackgroundColor, lineWidth: 2)
                            )
                    } else {
                        Capsule()
                            .fill(Color.fnGray3.opacity(0.1))
                    }
                }
            )
        }
    }
    
    private var modeBackgroundColor: Color {
        switch mode {
        case .solo: return .fnBlue
        case .duo: return .fnGreen
        case .squad: return .fnPurple
        }
    }
}
