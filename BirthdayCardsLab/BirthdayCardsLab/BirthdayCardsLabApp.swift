//
//  BirthdayCardsLabApp.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI
import SwiftData

@main
struct BirthdayCardsLabApp: App {
    let container: ModelContainer
    
    init() {
        do {
            // Create SwiftData container
            container = try ModelContainer(
                for: BirthdayCard.self,
                ThemeColor.self
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            BirthdayCardsMainView()
        }
        .modelContainer(container)
    }
}
