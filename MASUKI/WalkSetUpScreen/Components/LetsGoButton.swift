//
//  LetsGoButton.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct LetsGoButton: View {
    @AppStorage("letsGoButtonTopPadding") private var topPadding: Double = 0
    @AppStorage("letsGoButtonBottomPadding") private var bottomPadding: Double = 32
    @AppStorage("letsGoButtonHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("letsGoButtonFontSize") private var fontSize: Double = 22
    @AppStorage("letsGoButtonWidth") private var width: Double = 200
    @AppStorage("letsGoButtonHeight") private var height: Double = 64
    @AppStorage("letsGoButtonCornerRadius") private var cornerRadius: Double = 32
    @AppStorage("letsGoButtonShadowRadius") private var shadowRadius: Double = 8
    
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Let's Go")
                .font(.custom("Inter-SemiBold", size: fontSize))
                .foregroundColor(MasukiColors.oldLace)
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isEnabled ? MasukiColors.mediumJungle : MasukiColors.mediumJungle.opacity(0.5))
                        .shadow(
                            color: .black.opacity(isEnabled ? 0.2 : 0.1),
                            radius: shadowRadius,
                            x: 0,
                            y: 3
                        )
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    VStack(spacing: 20) {
        LetsGoButton(isEnabled: true, action: { print("Enabled tapped") })
        LetsGoButton(isEnabled: false, action: { print("Disabled tapped") })
    }
    .padding()
    .background(MasukiColors.adaptiveBackground)
}

