//
//  WalkSetupImageAreaView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct WalkSetupImageAreaView: View {
    // MARK: - Image Selection State
    @AppStorage("selectedImageId") private var selectedImageId: String = "koi"
    @State private var currentConfig: AnimatedImageConfig?
    
    // MARK: - WalkSetup Specific Layout Controls
    /// Separate @AppStorage keys for WalkSetup image
    @AppStorage("walkSetupImageTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSetupImageBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("walkSetupImageHorizontalPadding") private var horizontalPadding: Double = 0
    @AppStorage("walkSetupImageWidth") private var width: Double = 250
    @AppStorage("walkSetupImageHeight") private var height: Double = 250
    @AppStorage("walkSetupImageCornerRadius") private var cornerRadius: Double = 16
    @AppStorage("walkSetupImageShadowRadius") private var shadowRadius: Double = 8
    @AppStorage("walkSetupImageShadowOpacity") private var shadowOpacity: Double = 0.1
    
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
        
        WalkSetupImageAreaView()
    }
}
