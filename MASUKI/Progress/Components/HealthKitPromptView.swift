//
//  HealthKitPromptView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct HealthKitPromptView: View {
    let onEnableTap: () -> Void
    
    var body: some View {
        Button(action: onEnableTap) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(MasukiColors.mediumJungle)
                
                VStack(alignment: .leading, spacing: 4) {
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
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}
