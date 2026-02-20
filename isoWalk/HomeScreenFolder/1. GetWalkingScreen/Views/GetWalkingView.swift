//
//  GetWalkingView.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//

import SwiftUI

struct GetWalkingView: View {
    @Environment(SessionManager.self) private var sessionManager
    @AppStorage(IsoWalkThemes.selectedThemeKey) private var selectedThemeId: String = IsoWalkThemes.defaultThemeId
    private var theme: IsoWalkTheme { IsoWalkThemes.current(selectedId: selectedThemeId) }

    @State private var showingSetup = false

    var body: some View {
        ZStack {
            // Background Layer
            Group {
                if let bgName = theme.backgroundImageName {
                    Image(bgName).resizable().aspectRatio(contentMode: .fill)
                } else {
                    theme.backgroundColor
                }
            }
            .ignoresSafeArea()

            VStack {
                IsoWalkLogoView().padding(.top, 24)
                Spacer().frame(height: 16)
                ImageAreaView(theme: theme)
                Spacer()

                StartWalkingButton {
                    showingSetup = true
                }
                // This controls the placement of the "Start Walking" button
                .padding(.bottom, 124)
            }
        }
        // PROFESSIONAL CHOICE: Use fullScreenCover to hide the MainView's Nav Bar
        .fullScreenCover(isPresented: $showingSetup) {
            WalkSetUpView(
                onStartSession: { duration, music in
                    sessionManager.startSession(duration: duration, music: music)
                    showingSetup = false
                },
                onDismiss: {
                    showingSetup = false
                }
            )
        }
    }
}

#Preview {
    GetWalkingView()
        .environment(SessionManager())
}

