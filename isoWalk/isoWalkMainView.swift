//
//  isoWalkMainView.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  ROOT VIEW — intentionally dumb.
//  Owns tab state, the fullScreenCover, and the single BottomNavBar instance.
//  Has zero knowledge of walk sessions, alerts, or what any tab contains.
//
//  NAV BAR ROUTING:
//  Every tap unconditionally calls sessionNavCoordinator.route().
//  If WalkSessionView is active it has registered a handler and will
//  consume the tap, showing its confirmation alert.
//  If no session is active route() returns false and normal navigation runs.
//  This view never checks session state — it stays completely dumb.
//

import SwiftUI

struct isoWalkMainView: View {
    @State private var selectedTab: Int = 0
    @State private var showingSetup: Bool = false
    @Environment(SessionManager.self) private var sessionManager
    @Environment(SessionNavCoordinator.self) private var sessionNavCoordinator

    var body: some View {
        ZStack(alignment: .bottom) {

            // MARK: - Tab Content
            TabView(selection: Binding(
                get: { selectedTab },
                set: { newTab in
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        selectedTab = newTab
                    }
                }
            )) {
                GetWalkingView(onStartWalking: { showingSetup = true })
                    .tag(0)
                ProgressScreenView()
                    .tag(1)
                Text("Features Screen")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // MARK: - Nav Bar
            // Single instance for the entire app.
            // Always routes through sessionNavCoordinator first.
            // Session screen self-registers to intercept when active.
            BottomNavBar(
                selectedTab: $selectedTab,
                onTabReTap: {
                    // Re-tapping the current tab — offer to coordinator first.
                    // If no session active, fall through to normal re-tap behaviour.
                    if !sessionNavCoordinator.route(tab: selectedTab, isReTap: true) {
                        showingSetup = true
                    }
                },
                onTabChange: { tab in
                    // Changing to a different tab — offer to coordinator first.
                    // If no session active, fall through to normal tab switch.
                    if !sessionNavCoordinator.route(tab: tab, isReTap: false) {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            selectedTab = tab
                        }
                    }
                }
            )
        }
        // MARK: - fullScreenCover
        // WalkSetUpView owns its own NavigationStack and pushes WalkSessionView.
        // This view only knows the cover exists — nothing about what is inside.
        .fullScreenCover(isPresented: $showingSetup) {
            WalkSetUpView(
                selectedTab: $selectedTab,
                onDismiss: { showingSetup = false }
            )
        }
    }
}

#Preview {
    isoWalkMainView()
        .environment(SessionManager())
        .environment(SessionNavCoordinator())
}
