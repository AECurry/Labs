//
//  WalkSessionCoordinator.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//
//  COORDINATOR — handles navigation and confirmation logic for the walk session screen.
//  Keeps WalkSessionView dumb by owning all decision-making about what happens
//  when the user tries to leave or stop a session.
//

import SwiftUI
import Observation

@Observable
final class WalkSessionCoordinator {

    var currentAlert: SessionAlertType? = nil

    // Navigation callbacks — wired up by WalkSessionView
    var onNavigateToTab: ((Int) -> Void)?
    var onStopSession: (() -> Void)?

    // Timer pause/resume callbacks — wired up by WalkSessionView
    var onPauseForAlert: (() -> Void)?
    var onResumeAfterAlert: (() -> Void)?

    // Called by any button or tab that would trigger a destructive action.
    // Pauses the timer immediately before the alert appears.
    func handleTabTap(_ tab: Int) {
        onPauseForAlert?()
        currentAlert = .exitToTab(tab)
    }

    func handleStopButtonTap() {
        onPauseForAlert?()
        currentAlert = .stopSession
    }

    // Called by the alert's Cancel button via sessionConfirmationAlert modifier.
    func handleCancellation() {
        onResumeAfterAlert?()
    }

    func handleConfirmation(_ alertType: SessionAlertType) {
        // No need to resume — the session is ending.
        switch alertType {
        case .exitToTab(let tab):
            onNavigateToTab?(tab)
        case .stopSession:
            onStopSession?()
        }
    }
}
