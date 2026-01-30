//
//  MoreView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct MoreView: View {
    @State private var settingsManager = SettingsManager.shared
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    MoreScreenHeaderView()
                    
                    // Settings Section
                    SettingsSectionView(
                        isHealthKitEnabled: $settingsManager.isHealthKitEnabled
                    )
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    MoreView()
}
