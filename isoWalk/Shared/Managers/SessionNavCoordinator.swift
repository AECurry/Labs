//
//  SessionNavCoordinator.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  LOCATION: Shared/Managers/
//
//  PURPOSE:
//  The single piece of shared infrastructure that allows WalkSessionView
//  to temporarily own what happens when a BottomNavBar tab is tapped —
//  without isoWalkMainView or WalkSetUpView knowing anything about it.
//
//  PATTERN — environment-based delegation (same as SwiftUI's own \.dismiss):
//  • isoWalkApp injects one instance into the environment at the app root
//  • isoWalkMainView reads it and calls route() on every nav bar tap — always,
//    unconditionally. It never checks session state. It stays dumb.
//  • WalkSessionView registers its alert handler on .onAppear and
//    unregisters on .onDisappear. It is fully self-responsible.
//  • When no session is active, handler is nil and route() is a no-op,
//    so isoWalkMainView falls through to its own normal tab navigation.
//
//  No other file imports or references this coordinator except the three above.
//

import SwiftUI
import Observation

@Observable
final class SessionNavCoordinator {

    // Registered exclusively by WalkSessionView.
    // nil = no session active = nav bar behaves normally.
    private var handler: ((_ tab: Int, _ isReTap: Bool) -> Void)?

    // True only while WalkSessionView is on screen.
    var isSessionActive: Bool { handler != nil }

    // Called by isoWalkMainView on every nav bar tap — unconditionally.
    // Returns true if a handler consumed the tap (session is active),
    // false if the caller should handle it normally.
    @discardableResult
    func route(tab: Int, isReTap: Bool) -> Bool {
        guard let handler else { return false }
        handler(tab, isReTap)
        return true
    }

    // Called by WalkSessionView.onAppear only.
    func register(_ handler: @escaping (_ tab: Int, _ isReTap: Bool) -> Void) {
        self.handler = handler
    }

    // Called by WalkSessionView.onDisappear only.
    func unregister() {
        self.handler = nil
    }
}
