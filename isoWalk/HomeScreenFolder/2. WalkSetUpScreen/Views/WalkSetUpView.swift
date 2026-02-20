//
//  WalkSetUpView.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  PARENT VIEW — intentionally dumb.
//  Owns the ViewModel and all popup expanded states.
//  Modals rendered in root ZStack — guaranteed to float above everything.
//  Only one popup can be open at a time.

import SwiftUI

struct WalkSetUpView: View {
    @State private var viewModel = WalkSetUpViewModel()
    @State private var selectedTab: Int = 0
    @State private var paceExpanded: Bool = false
    @State private var durationExpanded: Bool = false
    @State private var musicExpanded: Bool = false
    @Environment(\.dismiss) private var dismiss
    @AppStorage(IsoWalkThemes.selectedThemeKey) private var selectedThemeId: String = IsoWalkThemes.defaultThemeId
    private var theme: IsoWalkTheme { IsoWalkThemes.current(selectedId: selectedThemeId) }

    let onStartSession: (DurationOptions, MusicOptions) -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            themeBackground

            // 1. MAIN CONTENT — static, never moves
            VStack(spacing: 0) {
                WalkSetUpHeader(theme: theme, onBack: { onDismiss() })
                    .padding(.bottom, 32)

                VStack(spacing: 12) {
                    PacePopUp(
                        selectedPace: $viewModel.selectedPace,
                        isExpanded: $paceExpanded
                    )
                    DurationPopUp(
                        selectedDuration: $viewModel.selectedDuration,
                        isExpanded: $durationExpanded
                    )
                    MusicPopUp(
                        selectedMusic: $viewModel.selectedMusic,
                        isExpanded: $musicExpanded
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                LetsGoButton(
                    isEnabled: viewModel.isReadyToStart,
                    action: {
                        viewModel.startWalkingSession()
                        onStartSession(viewModel.selectedDuration, viewModel.selectedMusic)
                    }
                )
                .padding(.bottom, 124)
            }

            // 2. POPUP MODALS — live in root ZStack, float above everything
            if paceExpanded {
                PacePopupModal(
                    selectedPace: $viewModel.selectedPace,
                    isExpanded: $paceExpanded
                )
                .ignoresSafeArea()
                .zIndex(10)
            }

            if durationExpanded {
                DurationPopupModal(
                    selectedDuration: $viewModel.selectedDuration,
                    isExpanded: $durationExpanded
                )
                .ignoresSafeArea()
                .zIndex(10)
            }

            if musicExpanded {
                MusicPopupModal(
                    selectedMusic: $viewModel.selectedMusic,
                    isExpanded: $musicExpanded
                )
                .ignoresSafeArea()
                .zIndex(10)
            }

            // 3. NAV BAR
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.bottom, 0)
                .zIndex(0)
        }
        // Ensure only one popup open at a time
        .onChange(of: paceExpanded) { if paceExpanded { durationExpanded = false; musicExpanded = false } }
        .onChange(of: durationExpanded) { if durationExpanded { paceExpanded = false; musicExpanded = false } }
        .onChange(of: musicExpanded) { if musicExpanded { paceExpanded = false; durationExpanded = false } }
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
    WalkSetUpView(
        onStartSession: { _, _ in print("Start") },
        onDismiss: { print("Dismiss") }
    )
}
