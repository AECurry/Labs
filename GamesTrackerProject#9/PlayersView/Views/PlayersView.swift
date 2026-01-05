//
//  PlayersView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData

// Main Parent View for PlayersView folder should be kept dumb

struct PlayersView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: PlayersViewModel?
    @State private var showingAddPlayer = false
    
    var body: some View {
        Group {
            if let viewModel = viewModel {
                PlayerListView(viewModel: viewModel)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingAddPlayer = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .foregroundColor(.fnBlue)
                            }
                        }
                    }
                    .navigationTitle("Players")
                    .navigationBarTitleDisplayMode(.large)
                    .sheet(isPresented: $showingAddPlayer) {
                        AddNewPlayerView()
                            .onDisappear {
                                viewModel.refreshStudents()
                            }
                    }
            } else {
                ProgressView("Loading...")
                    .foregroundColor(.fnWhite)
                    .onAppear {
                        viewModel = PlayersViewModel(modelContext: modelContext)
                        viewModel?.loadStudents()
                    }
            }
        }
    }
}
