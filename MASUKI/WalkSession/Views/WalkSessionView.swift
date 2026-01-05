//
//  WalkSessionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

// Main parent file for the WalkSessionn folder
import SwiftUI

struct WalkSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WalkSessionViewModel()
    
    // Passed from WalkSetupView
    let duration: DurationOption
    let music: MusicOption
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                WalkSessionHeader()
                
                WalkSessionTitle()
                
                WalkSessionImageAreaView()
                
                TimerDisplayView(
                    timeString: viewModel.formattedTime,
                    isActive: viewModel.timerState == .running
                )
                
                AudioVisualizerView(
                    amplitudes: viewModel.amplitudes,
                    isActive: viewModel.isAudioPlaying
                )
                
                PlaybackControlsView(
                    timerState: viewModel.timerState,
                    onPlayPause: {
                        viewModel.playPause()
                    },
                    onStop: {
                        viewModel.stopSession()
                    }
                )
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Start session if not already started
            if viewModel.activeSession == nil {
                    viewModel.startSession(duration: duration, music: music)
                }
            }
        .onDisappear {
            // Save session state when leaving
            viewModel.saveSessionState()
        }
    }
}

#Preview {
    WalkSessionView(
        duration: .twentyOne,
        music: .zenGarden
    )
}
