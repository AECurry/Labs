//
//  LayoutCustomizationView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/1/26.
//

import SwiftUI

struct LayoutCustomizationView: View {
    @Environment(\.dismiss) var dismiss
    
    // Header Settings
    @AppStorage("headerTopPadding") private var headerTopPadding: Double = 50
    @AppStorage("headerBottomPadding") private var headerBottomPadding: Double = 0
    @AppStorage("headerHorizontalPadding") private var headerHorizontalPadding: Double = 20
    @AppStorage("headerIconSize") private var headerIconSize: Double = 40
    @AppStorage("headerIconPadding") private var headerIconPadding: Double = 12
    
    // Title Settings
    @AppStorage("titleTopPadding") private var titleTopPadding: Double = 0
    @AppStorage("titleBottomPadding") private var titleBottomPadding: Double = 50
    @AppStorage("titleHorizontalPadding") private var titleHorizontalPadding: Double = 0
    @AppStorage("titleSpacing") private var titleSpacing: Double = 6
    @AppStorage("titleFontSize") private var titleFontSize: Double = 48
    @AppStorage("subtitleFontSize") private var subtitleFontSize: Double = 18
    
    // Image Settings
    @AppStorage("imageTopPadding") private var imageTopPadding: Double = 0
    @AppStorage("imageBottomPadding") private var imageBottomPadding: Double = 50
    @AppStorage("imageHorizontalPadding") private var imageHorizontalPadding: Double = 0
    @AppStorage("imageWidth") private var imageWidth: Double = 280
    @AppStorage("imageHeight") private var imageHeight: Double = 280
    @AppStorage("imageCornerRadius") private var imageCornerRadius: Double = 20
    @AppStorage("imageShadowRadius") private var imageShadowRadius: Double = 12
    @AppStorage("imageShadowOpacity") private var imageShadowOpacity: Double = 0.15
    @AppStorage("imageAnimationEnabled") private var imageAnimationEnabled: Bool = true
    @AppStorage("imageAnimationSpeed") private var imageAnimationSpeed: Double = 30
    @AppStorage("imageScaleAnimationEnabled") private var imageScaleAnimationEnabled: Bool = true
    @AppStorage("imageMinScale") private var imageMinScale: Double = 0.85
    @AppStorage("imageMaxScale") private var imageMaxScale: Double = 1.05
    @AppStorage("imageScaleSpeed") private var imageScaleSpeed: Double = 3.0
    
    // Button Settings
    @AppStorage("buttonTopPadding") private var buttonTopPadding: Double = 0
    @AppStorage("buttonBottomPadding") private var buttonBottomPadding: Double = 0
    @AppStorage("buttonHorizontalPadding") private var buttonHorizontalPadding: Double = 0
    @AppStorage("buttonFontSize") private var buttonFontSize: Double = 22
    @AppStorage("buttonWidth") private var buttonWidth: Double = 260
    @AppStorage("buttonHeight") private var buttonHeight: Double = 65
    @AppStorage("buttonCornerRadius") private var buttonCornerRadius: Double = 20
    @AppStorage("buttonShadowRadius") private var buttonShadowRadius: Double = 8
    
    // Bottom Nav Settings
    @AppStorage("bottomNavHeight") private var bottomNavHeight: Double = 80
    @AppStorage("bottomNavBottomPadding") private var bottomNavBottomPadding: Double = 12
    @AppStorage("bottomNavIconSize") private var bottomNavIconSize: Double = 32
    @AppStorage("bottomNavTextSize") private var bottomNavTextSize: Double = 12
    @AppStorage("bottomNavSpacing") private var bottomNavSpacing: Double = 4
    @AppStorage("bottomNavItemWidth") private var bottomNavItemWidth: Double = 72
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // HEADER SECTION
                    SectionCard(title: "Header Settings") {
                        SliderRow("Top Padding", value: $headerTopPadding, 0...100)
                        SliderRow("Bottom Padding", value: $headerBottomPadding, 0...100)
                        SliderRow("Side Padding", value: $headerHorizontalPadding, 0...50)
                        SliderRow("Icon Size", value: $headerIconSize, 20...60)
                        SliderRow("Icon Padding", value: $headerIconPadding, 0...24)
                    }
                    
                    // TITLE SECTION
                    SectionCard(title: "Title Settings") {
                        SliderRow("Top Padding", value: $titleTopPadding, 0...200)
                        SliderRow("Bottom Padding", value: $titleBottomPadding, 0...200)
                        SliderRow("Side Padding", value: $titleHorizontalPadding, 0...100)
                        SliderRow("Title Size", value: $titleFontSize, 32...80)
                        SliderRow("Subtitle Size", value: $subtitleFontSize, 14...30)
                        SliderRow("Spacing", value: $titleSpacing, 0...30)
                    }
                    
                    // IMAGE SECTION
                    SectionCard(title: "Image Settings") {
                        SliderRow("Top Padding", value: $imageTopPadding, 0...200)
                        SliderRow("Bottom Padding", value: $imageBottomPadding, 0...200)
                        SliderRow("Side Padding", value: $imageHorizontalPadding, 0...100)
                        SliderRow("Width", value: $imageWidth, 200...350)
                        SliderRow("Height", value: $imageHeight, 200...350)
                        SliderRow("Corner Radius", value: $imageCornerRadius, 0...40)
                        SliderRow("Shadow Radius", value: $imageShadowRadius, 0...30, step: 1)
                        SliderRow("Shadow Opacity", value: $imageShadowOpacity, 0...1, step: 0.05,
                                 formatter: { String(format: "%.2f", $0) })
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        // ROTATION ANIMATION
                        Toggle(isOn: $imageAnimationEnabled) {
                            Text("Rotation Animation")
                                .font(.custom("Inter-Medium", size: 14))
                                .foregroundColor(MasukiColors.coffeeBean)
                        }
                        .tint(MasukiColors.mediumJungle)
                        
                        if imageAnimationEnabled {
                            SliderRow("Rotation Speed", value: $imageAnimationSpeed, 5...60, step: 1,
                                     formatter: { "\(Int($0))s" })
                        }
                        
                        // SCALE ANIMATION (SIZE PULSING)
                        Toggle(isOn: $imageScaleAnimationEnabled) {
                            Text("Size Pulse Animation")
                                .font(.custom("Inter-Medium", size: 14))
                                .foregroundColor(MasukiColors.coffeeBean)
                        }
                        .tint(MasukiColors.mediumJungle)
                        
                        if imageScaleAnimationEnabled {
                            SliderRow("Min Size", value: $imageMinScale, 0.7...1.0, step: 0.01,
                                     formatter: { "\(Int($0 * 100))%" })
                            SliderRow("Max Size", value: $imageMaxScale, 1.0...1.3, step: 0.01,
                                     formatter: { "\(Int($0 * 100))%" })
                            SliderRow("Pulse Speed", value: $imageScaleSpeed, 1...10, step: 0.5,
                                     formatter: { String(format: "%.1fs", $0) })
                        }
                    }
                    
                    // BUTTON SECTION
                    SectionCard(title: "Button Settings") {
                        SliderRow("Top Padding", value: $buttonTopPadding, 0...200)
                        SliderRow("Bottom Padding", value: $buttonBottomPadding, 0...200)
                        SliderRow("Side Padding", value: $buttonHorizontalPadding, 0...100)
                        SliderRow("Font Size", value: $buttonFontSize, 16...36)
                        SliderRow("Width", value: $buttonWidth, 200...350)
                        SliderRow("Height", value: $buttonHeight, 50...100)
                        SliderRow("Corner Radius", value: $buttonCornerRadius, 8...40)
                        SliderRow("Shadow Radius", value: $buttonShadowRadius, 0...20, step: 1)
                    }
                    
                    // BOTTOM NAV SECTION
                    SectionCard(title: "Bottom Navigation") {
                        SliderRow("Bar Height", value: $bottomNavHeight, 60...120)
                        SliderRow("Bottom Padding", value: $bottomNavBottomPadding, 0...40)
                        SliderRow("Icon Size", value: $bottomNavIconSize, 24...48)
                        SliderRow("Text Size", value: $bottomNavTextSize, 10...16)
                        SliderRow("Icon-Text Spacing", value: $bottomNavSpacing, 0...12, step: 1)
                        SliderRow("Item Width", value: $bottomNavItemWidth, 60...100)
                    }
                    
                    // RESET BUTTON
                    Button {
                        resetAllToDefaults()
                    } label: {
                        Text("Reset All to Default")
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
            .navigationTitle("Customize Layout")
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
        // Header
        headerTopPadding = 50
        headerBottomPadding = 0
        headerHorizontalPadding = 20
        headerIconSize = 40
        headerIconPadding = 12
        
        // Title
        titleTopPadding = 0
        titleBottomPadding = 50
        titleHorizontalPadding = 0
        titleSpacing = 6
        titleFontSize = 48
        subtitleFontSize = 18
        
        // Image
        imageTopPadding = 0
        imageBottomPadding = 50
        imageHorizontalPadding = 0
        imageWidth = 280
        imageHeight = 280
        imageCornerRadius = 20
        imageShadowRadius = 12
        imageShadowOpacity = 0.15
        imageAnimationEnabled = true
        imageAnimationSpeed = 20.0
        imageScaleAnimationEnabled = true
        imageMinScale = 0.95
        imageMaxScale = 1.05
        imageScaleSpeed = 3.0
        
        // Button
        buttonTopPadding = 0
        buttonBottomPadding = 0
        buttonHorizontalPadding = 0
        buttonFontSize = 22
        buttonWidth = 260
        buttonHeight = 65
        buttonCornerRadius = 20
        buttonShadowRadius = 8
        
        // Bottom Nav
        bottomNavHeight = 80
        bottomNavBottomPadding = 12
        bottomNavIconSize = 32
        bottomNavTextSize = 12
        bottomNavSpacing = 4
        bottomNavItemWidth = 72
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("Inter-SemiBold", size: 18))
                .foregroundColor(MasukiColors.adaptiveText)
            
            content
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
}

// MARK: - Slider Row
struct SliderRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let formatter: (Double) -> String
    
    init(
        _ label: String,
        value: Binding<Double>,
        _ range: ClosedRange<Double>,
        step: Double = 5,
        formatter: @escaping (Double) -> String = { "\(Int($0))" }
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.formatter = formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.custom("Inter-Medium", size: 14))
                    .foregroundColor(MasukiColors.coffeeBean)
                
                Spacer()
                
                Text(formatter(value))
                    .font(.custom("Inter-SemiBold", size: 14))
                    .foregroundColor(MasukiColors.mediumJungle)
                    .monospacedDigit()
            }
            
            Slider(value: $value, in: range, step: step)
                .tint(MasukiColors.mediumJungle)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LayoutCustomizationView()
}

