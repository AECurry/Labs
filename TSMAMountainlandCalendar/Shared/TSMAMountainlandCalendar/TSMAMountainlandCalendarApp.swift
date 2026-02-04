//
//  TSMAMountainlandCalendarApp.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

@main
struct TSMAMountainlandCalendarApp: App {
    @State private var isAuthenticated = false
    
    init() {
        // Restore saved session when app launches
        APIController.shared.restoreSession()
        // Check if we have a valid session
        isAuthenticated = APIController.shared.isAuthenticated
    }
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                MainTabView()
            } else {
                StudentLoginView(onLoginSuccess: {
                    isAuthenticated = true
                })
            }
        }
    }
}
