//
//  ParkersRandomSelectorAppApp.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

import SwiftUI
import SwiftData

@main
struct ParkersRandomSelectorAppApp: App {
    var body: some Scene {
        WindowGroup {
            RandomSelectorMainView() // Entry point of the app
        }
        .modelContainer(for: User.self) // Sets up SwiftData persistence for User model
    }
}
