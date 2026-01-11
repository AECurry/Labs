//
//  MASUKIApp.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

@main
struct MASUKIApp: App {
    @State private var sessionManager = SessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            MasukiMainView()
                .environment(sessionManager)
        }
    }
}
