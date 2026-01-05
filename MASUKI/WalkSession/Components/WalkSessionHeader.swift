//
//  WalkSessionHeader.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionHeader: View {
    @AppStorage("walkSessionHeaderTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSessionHeaderBottomPadding") private var bottomPadding: Double = 8
    @AppStorage("walkSessionHeaderHorizontalPadding") private var horizontalPadding: Double = 16
    @AppStorage("walkSessionHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("walkSessionHeaderIconPadding") private var iconPadding: Double = 12
    
    // No back button per your request
    // Just minimal header space
    
    var body: some View {
        HStack {
            Spacer()
            
            // Could add settings icon here if needed
            // For now, just empty space
        }
        .frame(height: 44) // Standard navigation bar height
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    WalkSessionHeader()
        .background(MasukiColors.adaptiveBackground)
}
