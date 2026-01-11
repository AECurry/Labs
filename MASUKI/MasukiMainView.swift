//
//  MasukiMainView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/29/25.
//

import SwiftUI

struct MasukiMainView: View {
    @State private var selectedTab: Int = 0
    @State private var showWalkSetup: Bool = false
    @State private var showWalkSession: Bool = false
    @State private var sessionDuration: DurationOption = .twentyOne
    @State private var sessionMusic: MusicOption = .zenGarden
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            (colorScheme == .light ? MasukiColors.oldLace : MasukiColors.carbonBlack)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TabContentView(
                    selectedTab: selectedTab,
                    onStartWalking: { showWalkSetup = true }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                BottomNavBar(selectedTab: $selectedTab)
            }
        }
        // Walk Setup Cover
        .fullScreenCover(isPresented: $showWalkSetup) {
            WalkSetupViewSimple(
                onStartSession: { duration, music in
                    sessionDuration = duration
                    sessionMusic = music
                    showWalkSetup = false
                    showWalkSession = true
                },
                onDismiss: {
                    showWalkSetup = false
                }
            )
        }
        // Walk Session Cover
        .fullScreenCover(isPresented: $showWalkSession) {
            WalkSessionView(
                selectedTab: $selectedTab,
                duration: sessionDuration,
                music: sessionMusic,
                onDismissAll: {
                    // Close session and change tab happen together
                    showWalkSession = false
                }
            )
        }
    }
}

private struct TabContentView: View {
    let selectedTab: Int
    let onStartWalking: () -> Void

    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                GetWalkingViewSimple(onStartWalking: onStartWalking)
            case 1:
                ProgressView()
            case 2:
                MoreView()
            default:
                GetWalkingViewSimple(onStartWalking: onStartWalking)
            }
        }
    }
}

#Preview {
    MasukiMainView()
}
