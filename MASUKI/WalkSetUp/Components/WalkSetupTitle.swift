//
//  WalkSetupTitle.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct WalkSetupTitle: View {
    @AppStorage("walkSetupTitleTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSetupTitleBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("walkSetupTitleHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("walkSetupTitleSpacing") private var spacing: Double = 4
    
    @AppStorage("walkSetupTitleFontSize") private var fontSize: Double = 48
    @AppStorage("walkSetupSubtitleFontSize") private var subtitleFontSize: Double = 18
    
    var body: some View {
        VStack(spacing: spacing) {
            Text("MASUKI")
                .font(.custom("Spinnaker-Regular", size: fontSize))
                .foregroundColor(MasukiColors.carbonBlack)
            
            Text("(Ma-su-ki)")
                .font(.custom("Inter-Regular", size: subtitleFontSize))
                .foregroundColor(MasukiColors.coffeeBean)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    WalkSetupTitle()
        .background(MasukiColors.adaptiveBackground)
}
