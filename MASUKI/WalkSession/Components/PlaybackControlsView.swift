//
//  PlaybackControlsView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct PlaybackControlsView: View {
    @AppStorage("controlsTopPadding") private var topPadding: Double = 0
    @AppStorage("controlsBottomPadding") private var bottomPadding: Double = 40
    @AppStorage("controlsHorizontalPadding") private var horizontalPadding: Double = 40
    @AppStorage("controlsSpacing") private var spacing: Double = 40
    
    @AppStorage("controlButtonSize") private var buttonSize: Double = 70
    @AppStorage("controlIconSize") private var iconSize: Double = 32
    
    let timerState: TimerState
    let onPlayPause: () -> Void
    let onStop: () -> Void
    
    var isPlaying: Bool {
        timerState == .running
    }
    
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
            
            // Play/Pause Button
            ControlButton(
                iconName: isPlaying ? "pause.fill" : "play.fill",
                size: buttonSize * 1.2,
                iconSize: iconSize * 1.2,
                color: MasukiColors.mediumJungle,
                action: onPlayPause
            )
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
    }
}

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
