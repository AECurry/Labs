//
//  SwiftDataTodoListApp.swift
//  SwiftDataTodoList
//
//  Created by Parker Rushton on 5/30/25.
//

import SwiftUI
import SwiftData


@main
struct SwiftDataTodoListApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TodoItemsView()
        }
        .modelContainer(sharedModelContainer)
    }
}

