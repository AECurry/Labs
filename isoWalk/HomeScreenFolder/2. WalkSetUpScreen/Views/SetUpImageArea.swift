//
//  SetUpImageArea.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  COMPONENT — dumb child.
//  Displays the animated theme image at the smaller size used on the setup screen.
//  Separate from ImageAreaView (GetWalkingScreen) — same animation, different size.
//

import SwiftUI

struct SetUpImageArea: View {

    // MARK: - Input
    let theme: IsoWalkTheme

    // MARK: - Private Animation State
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0

    // MARK: - Body
    var body: some View {
        Image(theme.mainImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 180)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .id(theme.id)
            .onAppear { applyThemeAnimation() }
    }

    // MARK: - Animation Logic
    private func applyThemeAnimation() {
        switch theme.animationType {
        case .rotation(let speed):
            withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        case .pulse(let min, let max, let speed):
            scale = min
            withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
                scale = max
            }
        case .rotatingPulse(let rotSpeed, let minSc, let maxSc, let pulseSpeed):
            withAnimation(.linear(duration: rotSpeed).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            scale = minSc
            withAnimation(.easeInOut(duration: pulseSpeed).repeatForever(autoreverses: true)) {
                scale = maxSc
            }
        case .none:
            break
        }
    }
}

#Preview {
    ZStack {
        Image("GoldenTextureBackground")
            .resizable()
            .ignoresSafeArea()
        SetUpImageArea(theme: IsoWalkThemes.all[0])
    }
}

