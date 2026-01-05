//
//  WalkSessionTitle.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionTitle: View {
    @AppStorage("walkSessionTitleTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSessionTitleBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("walkSessionTitleHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("walkSessionTitleSpacing") private var spacing: Double = 4
    
    @AppStorage("walkSessionTitleFontSize") private var fontSize: Double = 36
    @AppStorage("walkSessionSubtitleFontSize") private var subtitleFontSize: Double = 14
    
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
    WalkSessionTitle()
        .background(MasukiColors.adaptiveBackground)
}
