//
//  isoWalkApp.swift
//  isoWalk
//
//  Created by AnnElaine on 2/12/26.
//

import SwiftUI

@main
struct isoWalkApp: App {
    // Initialize the Single Source of Truth for the Session
    @State private var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            isoWalkMainView()
                .environment(sessionManager)
        }
    }
}
