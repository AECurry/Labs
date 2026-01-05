//
//  WalkSessionCustomizationView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionCustomizationView: View {
    @Environment(\.dismiss) var dismiss
    
    // WalkSession Header Settings
    @AppStorage("walkSessionHeaderTopPadding") private var headerTopPadding: Double = 0
    @AppStorage("walkSessionHeaderBottomPadding") private var headerBottomPadding: Double = 8
    @AppStorage("walkSessionHeaderHorizontalPadding") private var headerHorizontalPadding: Double = 16
    
    // WalkSession Title Settings
    @AppStorage("walkSessionTitleTopPadding") private var titleTopPadding: Double = 0
    @AppStorage("walkSessionTitleBottomPadding") private var titleBottomPadding: Double = 0
    @AppStorage("walkSessionTitleHorizontalPadding") private var titleHorizontalPadding: Double = 0
    @AppStorage("walkSessionTitleSpacing") private var titleSpacing: Double = 4
    @AppStorage("walkSessionTitleFontSize") private var titleFontSize: Double = 36
    @AppStorage("walkSessionSubtitleFontSize") private var subtitleFontSize: Double = 14
    
    // WalkSession Image Settings
    @AppStorage("walkSessionImageTopPadding") private var imageTopPadding: Double = 0
    @AppStorage("walkSessionImageBottomPadding") private var imageBottomPadding: Double = 16
    @AppStorage("walkSessionImageHorizontalPadding") private var imageHorizontalPadding: Double = 0
    @AppStorage("walkSessionImageWidth") private var imageWidth: Double = 180
    @AppStorage("walkSessionImageHeight") private var imageHeight: Double = 180
    @AppStorage("walkSessionImageCornerRadius") private var imageCornerRadius: Double = 12
    @AppStorage("walkSessionImageShadowRadius") private var imageShadowRadius: Double = 6
    @AppStorage("walkSessionImageShadowOpacity") private var imageShadowOpacity: Double = 0.1
    
    // Timer Display Settings
    @AppStorage("timerDisplayTopPadding") private var timerDisplayTopPadding: Double = 0
    @AppStorage("timerDisplayBottomPadding") private var timerDisplayBottomPadding: Double = 16
    @AppStorage("timerDisplayHorizontalPadding") private var timerDisplayHorizontalPadding: Double = 0
    @AppStorage("timerFontSize") private var timerFontSize: Double = 64
    @AppStorage("timerLabelFontSize") private var timerLabelFontSize: Double = 18
    @AppStorage("timerSpacing") private var timerSpacing: Double = 8
    
    // Visualizer Settings
    @AppStorage("visualizerTopPadding") private var visualizerTopPadding: Double = 0
    @AppStorage("visualizerBottomPadding") private var visualizerBottomPadding: Double = 32
    @AppStorage("visualizerHorizontalPadding") private var visualizerHorizontalPadding: Double = 24
    @AppStorage("visualizerHeight") private var visualizerHeight: Double = 60
    @AppStorage("visualizerBarWidth") private var visualizerBarWidth: Double = 4
    @AppStorage("visualizerBarSpacing") private var visualizerBarSpacing: Double = 2
    @AppStorage("visualizerBarCornerRadius") private var visualizerBarCornerRadius: Double = 2
    
    // Controls Settings
    @AppStorage("controlsTopPadding") private var controlsTopPadding: Double = 0
    @AppStorage("controlsBottomPadding") private var controlsBottomPadding: Double = 40
    @AppStorage("controlsHorizontalPadding") private var controlsHorizontalPadding: Double = 40
    @AppStorage("controlsSpacing") private var controlsSpacing: Double = 40
    @AppStorage("controlButtonSize") private var controlButtonSize: Double = 70
    @AppStorage("controlIconSize") private var controlIconSize: Double = 32
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    SectionCard(title: "WalkSession Header Settings") {
                        SliderRow("Top Padding", value: $headerTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $headerBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $headerHorizontalPadding, 0...50)
                    }
                    
                    // Title Section
                    SectionCard(title: "WalkSession Title Settings") {
                        SliderRow("Top Padding", value: $titleTopPadding, 0...200)
                        SliderRow("Bottom Padding", value: $titleBottomPadding, 0...200)
                        SliderRow("Side Padding", value: $titleHorizontalPadding, 0...100)
                        SliderRow("Title Size", value: $titleFontSize, 24...60)
                        SliderRow("Subtitle Size", value: $subtitleFontSize, 12...24)
                        SliderRow("Spacing", value: $titleSpacing, 0...30)
                    }
                    
                    // Image Section
                    SectionCard(title: "WalkSession Image Settings") {
                        SliderRow("Top Padding", value: $imageTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $imageBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $imageHorizontalPadding, 0...50)
                        SliderRow("Width", value: $imageWidth, 120...250)
                        SliderRow("Height", value: $imageHeight, 120...250)
                        SliderRow("Corner Radius", value: $imageCornerRadius, 0...30)
                        SliderRow("Shadow Radius", value: $imageShadowRadius, 0...15, step: 1)
                        SliderRow("Shadow Opacity", value: $imageShadowOpacity, 0...1, step: 0.05,
                                 formatter: { String(format: "%.2f", $0) })
                    }
                    
                    // Timer Section
                    SectionCard(title: "Timer Display Settings") {
                        SliderRow("Top Padding", value: $timerDisplayTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $timerDisplayBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $timerDisplayHorizontalPadding, 0...50)
                        SliderRow("Timer Font Size", value: $timerFontSize, 48...96)
                        SliderRow("Label Font Size", value: $timerLabelFontSize, 14...24)
                        SliderRow("Spacing", value: $timerSpacing, 0...20)
                    }
                    
                    // Visualizer Section
                    SectionCard(title: "Audio Visualizer Settings") {
                        SliderRow("Top Padding", value: $visualizerTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $visualizerBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $visualizerHorizontalPadding, 0...50)
                        SliderRow("Height", value: $visualizerHeight, 30...100)
                        SliderRow("Bar Width", value: $visualizerBarWidth, 2...8)
                        SliderRow("Bar Spacing", value: $visualizerBarSpacing, 1...6)
                        SliderRow("Bar Corner Radius", value: $visualizerBarCornerRadius, 0...4)
                    }
                    
                    // Controls Section
                    SectionCard(title: "Playback Controls Settings") {
                        SliderRow("Top Padding", value: $controlsTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $controlsBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $controlsHorizontalPadding, 20...80)
                        SliderRow("Button Spacing", value: $controlsSpacing, 20...80)
                        SliderRow("Button Size", value: $controlButtonSize, 50...100)
                        SliderRow("Icon Size", value: $controlIconSize, 20...48)
                    }
                    
                    // Reset Button
                    Button {
                        resetAllToDefaults()
                    } label: {
                        Text("Reset WalkSession to Default")
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
            .navigationTitle("Customize WalkSession")
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
        
        // Title Defaults
        titleTopPadding = 0
        titleBottomPadding = 0
        titleHorizontalPadding = 0
        titleSpacing = 4
        titleFontSize = 36
        subtitleFontSize = 14
        
        // Image Defaults
        imageTopPadding = 0
        imageBottomPadding = 16
        imageHorizontalPadding = 0
        imageWidth = 180
        imageHeight = 180
        imageCornerRadius = 12
        imageShadowRadius = 6
        imageShadowOpacity = 0.1
        
        // Timer Defaults
        timerDisplayTopPadding = 0
        timerDisplayBottomPadding = 16
        timerDisplayHorizontalPadding = 0
        timerFontSize = 64
        timerLabelFontSize = 18
        timerSpacing = 8
        
        // Visualizer Defaults
        visualizerTopPadding = 0
        visualizerBottomPadding = 32
        visualizerHorizontalPadding = 24
        visualizerHeight = 60
        visualizerBarWidth = 4
        visualizerBarSpacing = 2
        visualizerBarCornerRadius = 2
        
        // Controls Defaults
        controlsTopPadding = 0
        controlsBottomPadding = 40
        controlsHorizontalPadding = 40
        controlsSpacing = 40
        controlButtonSize = 70
        controlIconSize = 32
    }
}

#Preview {
    WalkSessionCustomizationView()
}
