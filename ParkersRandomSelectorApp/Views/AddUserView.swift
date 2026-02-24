//
//  AddUserView.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

// DUMB CHILD VIEW - Form for adding new users
import SwiftUI

struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss // Dismiss sheet
    @Bindable var viewModel: RandomSelectorViewModel // Bindable for two-way updates
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter name", text: $viewModel.newUserName)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
                Button("Add User") {
                    viewModel.addUser()
                    dismiss() // Close sheet after adding
                }
                .disabled(viewModel.newUserName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("Add New User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.newUserName = "" // Clear input
                        dismiss()
                    }
                }
            }
        }
    }
}
