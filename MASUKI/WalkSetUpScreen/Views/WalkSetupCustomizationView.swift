//
//  WalkSetupCustomizationView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct WalkSetupCustomizationView: View {
    @Environment(\.dismiss) var dismiss
    
    // WalkSetup Header Settings
    @AppStorage("walkSetupHeaderTopPadding") private var headerTopPadding: Double = 0
    @AppStorage("walkSetupHeaderBottomPadding") private var headerBottomPadding: Double = 8
    @AppStorage("walkSetupHeaderHorizontalPadding") private var headerHorizontalPadding: Double = 16
    @AppStorage("walkSetupHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("walkSetupHeaderIconPadding") private var iconPadding: Double = 12
    
    // WalkSetup Title Settings
    @AppStorage("walkSetupTitleTopPadding") private var titleTopPadding: Double = 0
    @AppStorage("walkSetupTitleBottomPadding") private var titleBottomPadding: Double = 0
    @AppStorage("walkSetupTitleHorizontalPadding") private var titleHorizontalPadding: Double = 0
    @AppStorage("walkSetupTitleSpacing") private var titleSpacing: Double = 6
    @AppStorage("walkSetupTitleFontSize") private var titleFontSize: Double = 48
    @AppStorage("walkSetupSubtitleFontSize") private var subtitleFontSize: Double = 18
    
    // WalkSetup Image Settings
    @AppStorage("walkSetupImageTopPadding") private var imageTopPadding: Double = 0
    @AppStorage("walkSetupImageBottomPadding") private var imageBottomPadding: Double = 24
    @AppStorage("walkSetupImageHorizontalPadding") private var imageHorizontalPadding: Double = 0
    @AppStorage("walkSetupImageWidth") private var imageWidth: Double = 200
    @AppStorage("walkSetupImageHeight") private var imageHeight: Double = 200
    @AppStorage("walkSetupImageCornerRadius") private var imageCornerRadius: Double = 16
    @AppStorage("walkSetupImageShadowRadius") private var imageShadowRadius: Double = 8
    @AppStorage("walkSetupImageShadowOpacity") private var imageShadowOpacity: Double = 0.1
    
    // LetsGo Button Settings
    @AppStorage("letsGoButtonTopPadding") private var letsGoButtonTopPadding: Double = 0
    @AppStorage("letsGoButtonBottomPadding") private var letsGoButtonBottomPadding: Double = 32
    @AppStorage("letsGoButtonHorizontalPadding") private var letsGoButtonHorizontalPadding: Double = 0
    @AppStorage("letsGoButtonFontSize") private var letsGoButtonFontSize: Double = 22
    @AppStorage("letsGoButtonWidth") private var letsGoButtonWidth: Double = 200
    @AppStorage("letsGoButtonHeight") private var letsGoButtonHeight: Double = 64
    @AppStorage("letsGoButtonCornerRadius") private var letsGoButtonCornerRadius: Double = 32
    @AppStorage("letsGoButtonShadowRadius") private var letsGoButtonShadowRadius: Double = 8
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    SectionCard(title: "WalkSetup Header Settings") {
                        SliderRow("Top Padding", value: $headerTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $headerBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $headerHorizontalPadding, 0...50)
                        SliderRow("Icon Size", value: $iconSize, 20...60)
                        SliderRow("Icon Padding", value: $iconPadding, 0...24)
                    }
                    
                    // Title Section
                    SectionCard(title: "WalkSetup Title Settings") {
                        SliderRow("Top Padding", value: $titleTopPadding, 0...200)
                        SliderRow("Bottom Padding", value: $titleBottomPadding, 0...200)
                        SliderRow("Side Padding", value: $titleHorizontalPadding, 0...100)
                        SliderRow("Title Size", value: $titleFontSize, 32...80)
                        SliderRow("Subtitle Size", value: $subtitleFontSize, 14...30)
                        SliderRow("Spacing", value: $titleSpacing, 0...30)
                    }
                    
                    // Image Section
                    SectionCard(title: "WalkSetup Image Settings") {
                        SliderRow("Top Padding", value: $imageTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $imageBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $imageHorizontalPadding, 0...50)
                        SliderRow("Width", value: $imageWidth, 150...300)
                        SliderRow("Height", value: $imageHeight, 150...300)
                        SliderRow("Corner Radius", value: $imageCornerRadius, 0...40)
                        SliderRow("Shadow Radius", value: $imageShadowRadius, 0...20, step: 1)
                        SliderRow("Shadow Opacity", value: $imageShadowOpacity, 0...1, step: 0.05,
                                 formatter: { String(format: "%.2f", $0) })
                    }
                    
                    // LetsGo Button Section
                    SectionCard(title: "Let's Go Button Settings") {
                        SliderRow("Top Padding", value: $letsGoButtonTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $letsGoButtonBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $letsGoButtonHorizontalPadding, 0...50)
                        SliderRow("Font Size", value: $letsGoButtonFontSize, 16...36)
                        SliderRow("Width", value: $letsGoButtonWidth, 150...300)
                        SliderRow("Height", value: $letsGoButtonHeight, 50...100)
                        SliderRow("Corner Radius", value: $letsGoButtonCornerRadius, 8...40)
                        SliderRow("Shadow Radius", value: $letsGoButtonShadowRadius, 0...20, step: 1)
                    }
                    
                    // Reset Button
                    Button {
                        resetAllToDefaults()
                    } label: {
                        Text("Reset WalkSetup to Default")
                            .font(.custom("Inter-SemiBold", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(MasukiColors.tomatoJam)
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .navigationTitle("Customize WalkSetup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(MasukiColors.mediumJungle)
                }
            }
        }
    }
    
    private func resetAllToDefaults() {
        // Header Defaults
        headerTopPadding = 0
        headerBottomPadding = 8
        headerHorizontalPadding = 16
        iconSize = 40
        iconPadding = 12
        
        // Title Defaults
        titleTopPadding = 0
        titleBottomPadding = 0
        titleHorizontalPadding = 0
        titleSpacing = 6
        titleFontSize = 48
        subtitleFontSize = 18
        
        // Image Defaults
        imageTopPadding = 0
        imageBottomPadding = 24
        imageHorizontalPadding = 0
        imageWidth = 200
        imageHeight = 200
        imageCornerRadius = 16
        imageShadowRadius = 8
        imageShadowOpacity = 0.1
        
        // LetsGo Button Defaults
        letsGoButtonTopPadding = 0
        letsGoButtonBottomPadding = 32
        letsGoButtonHorizontalPadding = 0
        letsGoButtonFontSize = 24
        letsGoButtonWidth = 140
        letsGoButtonHeight = 64
        letsGoButtonCornerRadius = 32
        letsGoButtonShadowRadius = 8
    }
}

#Preview {
    WalkSetupCustomizationView()
}

