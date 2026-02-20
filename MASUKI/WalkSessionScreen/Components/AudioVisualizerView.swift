//
//  AudioVisualizerView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct AudioVisualizerView: View {
    @AppStorage("visualizerTopPadding") private var topPadding: Double = 0
    @AppStorage("visualizerBottomPadding") private var bottomPadding: Double = 32
    @AppStorage("visualizerHorizontalPadding") private var horizontalPadding: Double = 24
    
    @AppStorage("visualizerHeight") private var height: Double = 60
    @AppStorage("visualizerBarWidth") private var barWidth: Double = 4
    @AppStorage("visualizerBarSpacing") private var barSpacing: Double = 2
    @AppStorage("visualizerBarCornerRadius") private var barCornerRadius: Double = 2
    
    let amplitudes: [Float]
    let isActive: Bool
    
    private var normalizedAmplitudes: [CGFloat] {
        amplitudes.map { CGFloat($0) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: barSpacing) {
                ForEach(0..<30, id: \.self) { index in
                    VisualizerBar(
                        amplitude: normalizedAmplitudes[index],
                        isActive: isActive,
                        barWidth: barWidth,
                        barCornerRadius: barCornerRadius
                    )
                }
            }
            .frame(height: height)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

struct VisualizerBar: View {
    let amplitude: CGFloat
    let isActive: Bool
    let barWidth: Double
    let barCornerRadius: Double
    
    @State private var currentHeight: CGFloat = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: barCornerRadius)
            .fill(
                isActive ?
                MasukiColors.mediumJungle :
                MasukiColors.coffeeBean.opacity(0.3)
            )
            .frame(width: barWidth, height: currentHeight)
            .onAppear {
                currentHeight = 1
                animateBar()
            }
            .onChange(of: amplitude) { oldValue, newValue in
                animateBar()
            }
            .onChange(of: isActive) { oldValue, newValue in
                if !newValue {
                    withAnimation(.easeOut(duration: 0.3)) {
                        currentHeight = 1
                    }
                } else {
                    animateBar()
                }
            }
    }
    
    private func animateBar() {
        guard isActive else { return }
        
        let targetHeight = max(1, amplitude * 50)
        
        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
            currentHeight = targetHeight
        }
    }
}

#Preview {
    VStack {
        AudioVisualizerView(
            amplitudes: Array(repeating: 0.5, count: 30),
            isActive: true
        )
        AudioVisualizerView(
            amplitudes: Array(repeating: 0.1, count: 30),
            isActive: false
        )
    }
    .background(MasukiColors.adaptiveBackground)
}

