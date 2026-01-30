//
//  PlaybackControlsView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct PlaybackControlsView: View {
    // MARK: - Positioning Controls
    @AppStorage("controlsTopPadding") private var topPadding: Double = 0
    @AppStorage("controlsBottomPadding") private var bottomPadding: Double = 40
    @AppStorage("controlsHorizontalPadding") private var horizontalPadding: Double = 40
    @AppStorage("controlsSpacing") private var spacing: Double = 40
    
    // MARK: - Component Spacing (NEW)
    /// Controls the spacing between the AudioVisualizer and these controls
    @AppStorage("visualizerToControlsSpacing") private var fromVisualizerSpacing: Double = 32
    
    // MARK: - Button Styling
    @AppStorage("controlButtonSize") private var buttonSize: Double = 70
    @AppStorage("controlIconSize") private var iconSize: Double = 32
    
    // MARK: - External Dependencies
    let timerState: TimerState
    let onPlayPause: () -> Void
    let onStop: () -> Void
    
    // MARK: - Computed Properties
    var isPlaying: Bool {
        timerState == .running
    }
    
    // MARK: - View Body
    var body: some View {
        HStack(spacing: spacing) {
            // Stop Button
            ControlButton(
                iconName: "stop.fill",
                size: buttonSize,
                iconSize: iconSize,
                color: MasukiColors.tomatoJam,
                action: onStop
            )
            
            // Play/Pause Button - SAME SIZE as stop button
            ControlButton(
                iconName: isPlaying ? "pause.fill" : "play.fill",
                size: buttonSize,
                iconSize: iconSize,
                color: MasukiColors.mediumJungle,
                action: onPlayPause
            )
        }
        // Combined padding: internal top padding + spacing from visualizer
        .padding(.top, topPadding + fromVisualizerSpacing)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

// MARK: - ControlButton Subview
struct ControlButton: View {
    let iconName: String
    let size: Double
    let iconSize: Double
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .shadow(
                        color: color.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                
                Image(systemName: iconName)
                    .font(.system(size: iconSize, weight: .bold))
                    .foregroundColor(MasukiColors.oldLace)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: iconName)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        PlaybackControlsView(
            timerState: .stopped,
            onPlayPause: {},
            onStop: {}
        )
        
        PlaybackControlsView(
            timerState: .running,
            onPlayPause: {},
            onStop: {}
        )
        
        PlaybackControlsView(
            timerState: .paused,
            onPlayPause: {},
            onStop: {}
        )
    }
    .padding()
    .background(MasukiColors.adaptiveBackground)
}
