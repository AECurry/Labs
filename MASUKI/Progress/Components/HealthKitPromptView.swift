//
//  HealthKitPromptView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct HealthKitPromptView: View {
    let onEnableTap: () -> Void
    
    // Component controls its own spacing
    @AppStorage("healthKitTopPadding") private var topPadding: Double = 0
    @AppStorage("healthKitBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("healthKitHorizontalPadding") private var horizontalPadding: Double = 16
    
    // Internal spacing
    private let internalSpacing: CGFloat = 4
    private let iconSize: CGFloat = 20
    
    var body: some View {
        Button(action: onEnableTap) {
            HStack(spacing: 12) {
                Image(systemName: "heart.fill")
                    .font(.system(size: iconSize))
                    .foregroundColor(MasukiColors.mediumJungle)
                
                VStack(alignment: .leading, spacing: internalSpacing) {
                    Text("Enable HealthKit")
                        .font(.custom("Inter-SemiBold", size: 16))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    Text("Track your walking progress in Apple Health")
                        .font(.custom("Inter-Regular", size: 12))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(MasukiColors.mediumJungle)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(MasukiColors.mediumJungle.opacity(0.1))
                    .stroke(MasukiColors.mediumJungle.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}
