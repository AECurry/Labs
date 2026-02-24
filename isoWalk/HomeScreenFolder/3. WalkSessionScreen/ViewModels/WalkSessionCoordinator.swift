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

    var onNavigateToTab: ((Int) -> Void)?
    var onStopSession: (() -> Void)?

    func handleTabTap(_ tab: Int) {
        currentAlert = .exitToTab(tab)
    }

    func handleStopButtonTap() {
        currentAlert = .stopSession
    }

    func handleConfirmation(_ alertType: SessionAlertType) {
        switch alertType {
        case .exitToTab(let tab):
            onNavigateToTab?(tab)
        case .stopSession:
            onStopSession?()
        }
    }
}
