//
//  WalkSessionView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI

struct WalkSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int
    @State private var viewModel = WalkSessionViewModel()
    @State private var coordinator = WalkSessionCoordinator()

    let duration: DurationOption
    let music: MusicOption

    var onDismissAll: (() -> Void)?

    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                WalkSessionHeader(onBack: {
                    coordinator.handleStopButtonTap()
                })

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
                    onPlayPause: { viewModel.playPause() },
                    onStop: { coordinator.handleStopButtonTap() }
                )

                Spacer()

                BottomNavBar(
                    selectedTab: $selectedTab,
                    onTabTap: { tab in
                        coordinator.handleTabTap(tab)
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupCoordinator()
            viewModel.initializeSession(duration: duration, music: music)
        }
        .onDisappear {
            viewModel.saveSessionState()
        }
        .sessionConfirmationAlert(alertType: $coordinator.currentAlert) { alertType in
            coordinator.handleConfirmation(alertType)
        }
    }

    private func setupCoordinator() {
        coordinator.onNavigateToTab = { tab in
            viewModel.stopSession()
            
            // Change tab FIRST
            selectedTab = tab
            
            // Then dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onDismissAll?()
            }
        }

        coordinator.onStopSession = {
            viewModel.stopSession()
            dismiss()
        }
    }
}

#Preview {
    @Previewable @State var selectedTab = 0
    WalkSessionView(
        selectedTab: $selectedTab,
        duration: .twentyOne,
        music: .zenGarden
    )
}
