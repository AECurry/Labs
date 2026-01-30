//
//  StartWalkingButton.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct StartWalkingButton: View {
    @AppStorage("buttonTopPadding") private var topPadding: Double = 0
    @AppStorage("buttonBottomPadding") private var bottomPadding: Double = 32
    @AppStorage("buttonHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("buttonFontSize") private var fontSize: Double = 22
    @AppStorage("buttonWidth") private var width: Double = 200
    @AppStorage("buttonHeight") private var height: Double = 64
    @AppStorage("buttonCornerRadius") private var cornerRadius: Double = 32
    @AppStorage("buttonShadowRadius") private var shadowRadius: Double = 8
    
    let action: () -> Void  // This should be called when tapped
    
    var body: some View {
        Button(action: action) {  // Make sure this calls the action
            Text("Start Walking")
                .font(.custom("Inter-SemiBold", size: fontSize))
                .foregroundColor(MasukiColors.oldLace)
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(MasukiColors.mediumJungle)
                        .shadow(
                            color: .black.opacity(0.2),
                            radius: shadowRadius,
                            x: 0,
                            y: 3
                        )
                )
        }
        .buttonStyle(.plain)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    StartWalkingButton {
        print("Button tapped")
    }
}
