//
//  LifeCycle_LabApp.swift
//  LifeCycle Lab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

@main
struct LifeCycleLabApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // This would need to be handled through a shared state manager
            // For now, we'll rely on the UI interactions
            print("Scene phase changed from \(oldPhase) to \(newPhase)")
        }
    }
}
