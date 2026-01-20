//
//  TodaySectionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct TodaySectionView: View {
    let todayMiles: Double
    
    // Component controls its own spacing
    @AppStorage("todaySectionTopPadding") private var topPadding: Double = 40
    @AppStorage("todaySectionBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("todaySectionHorizontalPadding") private var horizontalPadding: Double = 0
    
    // Internal spacing
    private let headingSpacing: CGFloat = 24
    private let gridSpacing: CGFloat = 16
    private let cardSpacing: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: headingSpacing) {
            // "Today" heading
            Text("Today")
                .font(.custom("Spinnaker-Regular", size: 36))
                .foregroundColor(MasukiColors.adaptiveText)
            
            // 2x2 Grid of action cards
            VStack(spacing: gridSpacing) {
                HStack(spacing: gridSpacing) {
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
                
                HStack(spacing: gridSpacing) {
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
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

struct ActionCard: View {
    let title: String
    let iconName: String
    let destinationTab: Int?
    
    // Card controls its own internal spacing
    private let iconSize: CGFloat = 32
    private let cardSpacing: CGFloat = 16
    private let cornerRadius: CGFloat = 16
    private let minHeight: CGFloat = 120
    
    var body: some View {
        Button(action: handleTap) {
            VStack(spacing: cardSpacing) {
                Image(systemName: iconName)
                    .font(.system(size: iconSize))
                    .foregroundColor(MasukiColors.mediumJungle)
                
                Text(title)
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .background(MasukiColors.claySoil.opacity(0.8))
            .cornerRadius(cornerRadius)
        }
        .buttonStyle(.plain)
    }
    
    private func handleTap() {
        if let tab = destinationTab {
            print("Navigating to tab \(tab)")
        } else {
            print("Tapped \(title)")
        }
    }
}

#Preview {
    TodaySectionView(todayMiles: 3.5)
}
