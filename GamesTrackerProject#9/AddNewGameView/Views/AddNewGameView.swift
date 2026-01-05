//
//  AddNewGameView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

// Main Parent View for AddNewGameView folder should be kept dumb

import SwiftUI
import SwiftData

struct AddNewGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddGameViewModel?
    
    @Query(sort: \Student.name) private var allStudents: [Student]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                if let viewModel = viewModel {
                    // FIXED: Remove the broken createdGameId binding
                    AddGameContentView(
                        viewModel: viewModel,
                        allStudents: allStudents
                    )
                } else {
                    ProgressView("Loading...")
                        .foregroundColor(.fnWhite)
                        .onAppear {
                            viewModel = AddGameViewModel(modelContext: modelContext)
                        }
                }
            }
            .navigationTitle("Create New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.fnWhite)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Student.self, Game.self, Team.self, configurations: config)
    
    Student.seedPreviewData(into: container.mainContext)
    
    return AddNewGameView()
        .modelContainer(container)
}
