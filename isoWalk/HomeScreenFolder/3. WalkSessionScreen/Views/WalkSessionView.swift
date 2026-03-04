//
//  WalkSessionView.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  PARENT VIEW — intentionally dumb.
//  Owns the ViewModel and Coordinator. Passes bindings down to children.
//  Zero business logic — all decisions live in Coordinator and ViewModel.
//
//  BOTTOM NAV BAR:
//  This view owns its own BottomNavBar instance inside its ZStack.
//  Every tap — back button, stop button, AND nav bar tabs — is wired
//  directly to WalkSessionCoordinator using the exact same pattern.
//  The coordinator handles the alert. No shared infrastructure needed.
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
        ZStack(alignment: .bottom) {
            themeBackground

            VStack(spacing: 0) {
                WalkSessionHeader(onBack: {
                    coordinator.handleBackButtonTap()
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
            }
            .padding(.bottom, 100) // keeps content above the nav bar

            // MARK: - BottomNavBar
            // Owned by this view. Every tap wired to coordinator —
            // identical pattern to the back button and stop button above.
            // Re-tapping the current tab treats as back (leave session).
            // Tapping a different tab confirms before navigating away.
            BottomNavBar(
                selectedTab: $selectedTab,
                onTabReTap: {
                    coordinator.handleBackButtonTap()
                },
                onTabChange: { tab in
                    coordinator.handleTabTap(tab)
                }
            )
        }
        .navigationBarHidden(true)
        .onAppear {
            let c = coordinator
            let vm = viewModel
            let dismissAll = onDismissAll

            c.onPauseForAlert    = { vm.pauseForAlert() }
            c.onResumeAfterAlert = { vm.resumeAfterAlert() }
            c.onBackToSetup      = { vm.stopSession(); dismiss() }
            c.onStopSession      = { vm.stopSession() }
            c.onNavigateToTab    = { tab in
                vm.stopSession()
                selectedTab = tab
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismissAll?()
                }
            }

            vm.initializeSession(duration: duration, pace: pace, music: music)
        }
        .onDisappear {
            viewModel.saveSessionState()
        }
        .onChange(of: scenePhase) { _, newPhase in
            viewModel.handleScenePhase(newPhase)
        }
        .alert(
            coordinator.alertType?.title ?? "",
            isPresented: $coordinator.showAlert
        ) {
            Button("Cancel", role: .cancel) { coordinator.cancelAlert() }
            Button(coordinator.alertType?.confirmButtonText ?? "Confirm",
                   role: .destructive) { coordinator.confirmAlert() }
        } message: {
            Text(coordinator.alertType?.message ?? "")
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
