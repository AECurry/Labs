//
//  RandomSelectorMainView.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

// SMART PARENT VIEW - Owns ViewModel and coordinates all child views
import SwiftUI
import SwiftData

struct RandomSelectorMainView: View {
    @State private var viewModel = RandomSelectorViewModel() // Owns all logic
    @Environment(\.modelContext) private var modelContext // SwiftData connection
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content
                VStack(spacing: 0) {
                    // Child: Displays list of users
                    UserListView(
                        users: viewModel.users,
                        selectedUsers: viewModel.selectedUsers,
                        onDelete: { user in
                            viewModel.deleteUser(user)
                        },
                        onMove: { source, destination in
                            viewModel.moveUsers(from: source, to: destination)
                        },
                        onEdit: { user, newName in
                            viewModel.updateUserName(user, newName: newName)
                        }
                    )
                    
                    // Child: Selection stepper and GO button
                    SelectionControlsView(
                        selectionCount: $viewModel.selectionCount,
                        userCount: min(viewModel.users.count, 8),
                        onGo: startSelectionAnimation,
                        isDisabled: viewModel.users.isEmpty
                    )
                }
                
                // Results Popup (overlay)
                if viewModel.showResultsPopup {
                    // Semi-transparent background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showResultsPopup = false
                        }
                    
                    // Child: Black popup with selected names
                    ResultsPopupView(
                        selectedUsers: Array(viewModel.selectedUsers),
                        onClose: {
                            viewModel.showResultsPopup = false
                        }
                    )
                }
            }
            .navigationTitle("Random Selector")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showAddUserSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddUserSheet) {
                AddUserView(viewModel: viewModel) // Child: Add user form
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                viewModel.setup(with: modelContext) // Initialize ViewModel
            }
        }
    }
    
    // Trigger random selection and show results
    private func startSelectionAnimation() {
        let selected = viewModel.performRandomSelection()
        if !selected.isEmpty {
            viewModel.showResultsPopup = true
        }
    }
}

#Preview {
    RandomSelectorMainView()
}
