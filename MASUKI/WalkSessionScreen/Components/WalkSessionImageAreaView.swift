//
//  WalkSessionImageAreaView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionImageAreaView: View {
    @AppStorage("selectedImageId") private var selectedImageId: String = "koi"
    
    // WalkSession Specific Layout Controls
    @AppStorage("walkSessionImageTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSessionImageBottomPadding") private var bottomPadding: Double = 16
    @AppStorage("walkSessionImageHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("walkSessionImageWidth") private var width: Double = 180
    @AppStorage("walkSessionImageHeight") private var height: Double = 180
    @AppStorage("walkSessionImageCornerRadius") private var cornerRadius: Double = 12
    @AppStorage("walkSessionImageShadowRadius") private var shadowRadius: Double = 6
    @AppStorage("walkSessionImageShadowOpacity") private var shadowOpacity: Double = 0.1
    
    var body: some View {
        // Get the current image config
        let config = AnimatedImageLibrary.getImage(byId: selectedImageId)
        
        // Static display during walk session
        Image(config?.imageName ?? "JapaneseKoi")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
            .shadow(
                color: .black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,
                y: 4
            )
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    ZStack {
        MasukiColors.adaptiveBackground
            .ignoresSafeArea()
        
        WalkSessionImageAreaView()
    }
}

