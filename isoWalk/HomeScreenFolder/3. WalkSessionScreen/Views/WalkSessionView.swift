//
//  WalkSessionView.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  PARENT VIEW — intentionally dumb.
//  Owns the ViewModel and Coordinator. Passes bindings down to children.
//  Zero layout logic beyond assembling components.
//

import SwiftUI

struct WalkSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTab: Int
    @State private var viewModel = WalkSessionViewModel()
    @State private var coordinator = WalkSessionCoordinator()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(IsoWalkThemes.selectedThemeKey) private var selectedThemeId: String = IsoWalkThemes.defaultThemeId
    private var theme: IsoWalkTheme { IsoWalkThemes.current(selectedId: selectedThemeId) }

    let duration: DurationOptions
    let pace: PaceOptions
    let music: MusicOptions
    var onDismissAll: (() -> Void)?

    var body: some View {
        ZStack {
            themeBackground

            VStack(spacing: 0) {
                WalkSessionHeader(onBack: {
                    coordinator.handleStopButtonTap()
                })

                WalkSessionImageArea(theme: theme)

                TimerDisplay(
                    timeString: viewModel.formattedTime,
                    isActive: viewModel.timerState == .running
                )

                AudioVisualizer(
                    amplitudes: viewModel.amplitudes,
                    isActive: viewModel.isAudioPlaying
                )

                PlaybackControls(
                    timerState: viewModel.timerState,
                    onPlayPause: { viewModel.playPause() },
                    onStop: { coordinator.handleStopButtonTap() }
                )

                Spacer()

                BottomNavBar(selectedTab: $selectedTab, onTabReTap: {
                    viewModel.stopSession() // Stop the timer/music
                    onDismissAll?()        // Return all the way to GetWalkingView
                })
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupCoordinator()
            viewModel.initializeSession(duration: duration, pace: pace, music: music)
        }
        .onDisappear {
            viewModel.saveSessionState()
        }
        .onChange(of: scenePhase) { _, newPhase in
            viewModel.handleScenePhase(newPhase)
        }
        .sessionConfirmationAlert(alertType: $coordinator.currentAlert) { alertType in
            coordinator.handleConfirmation(alertType)
        }
    }

    @ViewBuilder
    private var themeBackground: some View {
        if let bgName = theme.backgroundImageName {
            Image(bgName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        } else {
            theme.backgroundColor.ignoresSafeArea()
        }
    }

    private func setupCoordinator() {
        coordinator.onNavigateToTab = { tab in
            viewModel.stopSession()
            selectedTab = tab
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
        pace: .steady,
        music: .placeholder
    )
}
