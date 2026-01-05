//
//  WalkSessionImageAreaView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionImageAreaView: View {
    // MARK: - Image Selection State
    @AppStorage("selectedImageId") private var selectedImageId: String = "koi"
    @State private var currentConfig: AnimatedImageConfig?
    
    // MARK: - WalkSession Specific Layout Controls
    @AppStorage("walkSessionImageTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSessionImageBottomPadding") private var bottomPadding: Double = 16
    @AppStorage("walkSessionImageHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("walkSessionImageWidth") private var width: Double = 180
    @AppStorage("walkSessionImageHeight") private var height: Double = 180
    @AppStorage("walkSessionImageCornerRadius") private var cornerRadius: Double = 12
    @AppStorage("walkSessionImageShadowRadius") private var shadowRadius: Double = 6
    @AppStorage("walkSessionImageShadowOpacity") private var shadowOpacity: Double = 0.1
    
    // MARK: - Animation State
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image(currentConfig?.imageName ?? "JapaneseKoi")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
            .rotationEffect(.degrees(currentConfig?.isRotationEnabled == true ? rotation : 0))
            .scaleEffect(currentConfig?.isScaleEnabled == true ? scale : 1.0)
            .shadow(
                color: .black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,
                y: 4
            )
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .padding(.horizontal, horizontalPadding)
            .onAppear {
                loadCurrentConfig()
                startAnimations()
            }
            .onChange(of: selectedImageId) { oldValue, newValue in
                loadCurrentConfig()
                restartAnimations()
            }
    }
    
    private func loadCurrentConfig() {
        currentConfig = AnimatedImageLibrary.getImage(byId: selectedImageId)
    }
    
    private func startAnimations() {
        guard let config = currentConfig else { return }
        
        if config.isRotationEnabled {
            withAnimation(
                .linear(duration: config.rotationSpeed)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
        
        if config.isScaleEnabled {
            scale = config.minScale
            
            withAnimation(
                .easeInOut(duration: config.scaleSpeed)
                    .repeatForever(autoreverses: true)
            ) {
                scale = config.maxScale
            }
        }
    }
    
    private func restartAnimations() {
        rotation = 0
        scale = 1.0
        startAnimations()
    }
}

#Preview {
    ZStack {
        MasukiColors.adaptiveBackground
            .ignoresSafeArea()
        
        WalkSessionImageAreaView()
    }
}
