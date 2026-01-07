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
    var showExitConfirmation = false
    var showSettingsConfirmation = false
    var targetTab: Int? = nil
    
    // Callback to parent to change tabs
    var onNavigateToTab: ((Int) -> Void)?
    var onDismiss: (() -> Void)?
    
    func handleBackButtonTap() {
        showSettingsConfirmation = true
    }
    
    func handleTabTap(_ tab: Int) {
        targetTab = tab
        showExitConfirmation = true
    }
    
    func confirmExit() {
        if let targetTab = targetTab {
            onNavigateToTab?(targetTab)
        }
        onDismiss?()
    }
    
    func confirmSettings() {
        // Assuming Settings is in More tab (tab 2)
        onNavigateToTab?(2)
        onDismiss?()
    }
    
    func cancelNavigation() {
        targetTab = nil
    }
}
