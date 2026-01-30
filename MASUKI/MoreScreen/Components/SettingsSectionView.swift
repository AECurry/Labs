//
//  SettingsSectionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct SettingsSectionView: View {
    @Binding var isHealthKitEnabled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.custom("Spinnaker-Regular", size: 28))
                .foregroundColor(MasukiColors.adaptiveText)
                .padding(.horizontal)
            
            // HealthKit Toggle
            SettingRow(
                icon: "heart.fill",
                title: "HealthKit Integration",
                subtitle: "Track walking distance in Apple Health",
                isEnabled: $isHealthKitEnabled
            )
            
            // Add more settings as needed...
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(MasukiColors.mediumJungle)
                .frame(width: 40)
            
            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter-SemiBold", size: 16))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Text(subtitle)
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundColor(MasukiColors.coffeeBean)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: MasukiColors.mediumJungle))
                .labelsHidden()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(MasukiColors.adaptiveBackground.opacity(0.5))
        )
        .padding(.horizontal)
    }
}
