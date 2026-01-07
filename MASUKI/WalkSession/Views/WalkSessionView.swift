//
//  WalkSessionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

// Main parent file for the WalkSession folder
import SwiftUI

struct WalkSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WalkSessionViewModel()
    
    // Required parameters FIRST
    let duration: DurationOption
    let music: MusicOption
    
    // Optional parameters LAST
    var onBackButtonTap: (() -> Void)?
    var onTabTap: ((Int) -> Void)?
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back button and Masuki icon
                WalkSessionHeader(onBack: {
                    onBackButtonTap?()
                })
                
                // Title (MASUKI and pronunciation)
                WalkSessionTitle()
                
                // Static image (no animation during session)
                WalkSessionImageAreaView()
                
                // Timer display with countdown
                TimerDisplayView(
                    timeString: viewModel.formattedTime,
                    isActive: viewModel.timerState == .running
                )
                
                // Audio visualizer bars
                AudioVisualizerView(
                    amplitudes: viewModel.amplitudes,
                    isActive: viewModel.isAudioPlaying
                )
                
                // Playback controls
                PlaybackControlsView(
                    timerState: viewModel.timerState,
                    onPlayPause: {
                        viewModel.playPause()
                    },
                    onStop: {
                        viewModel.stopSession()
                        dismiss()
                    }
                )
                
                Spacer()
                
                // BottomNavBar - parent handles navigation
                BottomNavBar(selectedTab: .constant(0), onTabTap: { tab in
                    onTabTap?(tab)
                })
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.initializeSession(duration: duration, music: music)
        }
        .onDisappear {
            viewModel.saveSessionState()
        }
    }
}

#Preview {
    WalkSessionView(
        duration: .twentyOne,
        music: .zenGarden,
        onBackButtonTap: {
            print("Back button tapped")
        },
        onTabTap: { tab in
            print("Tab \(tab) tapped")
        }
    )
}
