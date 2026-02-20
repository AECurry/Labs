//
//  WalkSessionCoordinator.swift
//  MASUKI
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI
import Observation

@Observable
class WalkSessionCoordinator {
    var currentAlert: SessionAlertType? = nil
    var targetTab: Int? = nil
    
    var onNavigateToTab: ((Int) -> Void)?
    var onStopSession: (() -> Void)?
    
    func handleTabTap(_ tab: Int) {
        targetTab = tab
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

