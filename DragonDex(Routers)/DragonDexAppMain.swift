//
//  DragonDexAppMain.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

@main
struct DragonDexApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(
                for: Dragon.self, Power.self, Rider.self,
                configurations: ModelConfiguration("DragonDex")
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(container)
        }
    }
}
