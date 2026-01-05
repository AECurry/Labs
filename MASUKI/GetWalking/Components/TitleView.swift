//
//  TitleView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct TitleView: View {
    // TITLE POSITIONING (Self-Contained Spacing)
    @AppStorage("titleTopPadding") private var topPadding: Double = 0
    @AppStorage("titleBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("titleHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("titleSpacing") private var spacing: Double = 6
    
    // TITLE FONTS
    @AppStorage("titleFontSize") private var fontSize: Double = 48
    @AppStorage("subtitleFontSize") private var subtitleFontSize: Double = 18
    
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
    TitleView()
}
