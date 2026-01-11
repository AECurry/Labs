//
//  TodaySectionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct TodaySectionView: View {
    let todayMiles: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // "Today" heading
            Text("Today")
                .font(.custom("Spinnaker-Regular", size: 36))
                .foregroundColor(MasukiColors.adaptiveText)
                .padding(.horizontal, 32)
            
            // 2x2 Grid of action cards
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ActionCard(
                        title: "Get Walking",
                        iconName: "figure.walk",
                        destinationTab: 0
                    )
                    
                    ActionCard(
                        title: "Progress",
                        iconName: "chart.line.uptrend.xyaxis",
                        destinationTab: nil
                    )
                }
                
                HStack(spacing: 16) {
                    ActionCard(
                        title: "More",
                        iconName: "ellipsis.circle",
                        destinationTab: 2
                    )
                    
                    ActionCard(
                        title: "Settings",
                        iconName: "gearshape.fill",
                        destinationTab: nil
                    )
                }
            }
            .padding(.horizontal, 32)
        }
        .padding(.top, 8)
    }
}

// New ActionCard component for Today section
struct ActionCard: View {
    let title: String
    let iconName: String
    let destinationTab: Int? // nil if not a tab navigation
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: handleTap) {
            VStack(spacing: 16) {
                Image(systemName: iconName)
                    .font(.system(size: 32))
                    .foregroundColor(MasukiColors.mediumJungle)
                
                Text(title)
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(MasukiColors.claySoil.opacity(0.8))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
    
    private func handleTap() {
        if let tab = destinationTab {
            // You'll need to pass a binding to selectedTab or use Navigation
            // For now, we'll just print
            print("Navigating to tab \(tab)")
        } else {
            // Handle non-tab destinations
            print("Tapped \(title)")
        }
    }
}

// Placeholder card (optional - keep if needed elsewhere)
struct PlaceholderCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(MasukiColors.claySoil)
            .frame(height: 120)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodaySectionView(todayMiles: 3.5)
}
