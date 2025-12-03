//
//  AddUserView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/2/25.
//

import SwiftUI
import SwiftData

// View for adding a new user to the app
struct AddUserView: View {
    // @Environment gives us access to SwiftData's model context for database operations
    @Environment(\.modelContext) private var modelContext
    
    // @Environment gives us access to the dismiss action to close this view
    @Environment(\.dismiss) private var dismiss
    
    // @State creates a local state variable that SwiftUI watches for changes
       // When userName changes, SwiftUI automatically updates the TextField
    @State private var userName = ""
    
    
    var body: some View {
        // NavigationStack provides the navigation bar at the top
        NavigationStack {
            
            // Form provides the standard grouped appearance for input fields
            Form {
                
                // TextField is bound to userName with two-way binding ($)
                // Any changes in the field update userName, and vice versa
                TextField("Name or Nickname", text: $userName)
                    .autocapitalization(.words)
            }
            .navigationTitle("Add User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button on the left side of the nav bar
                ToolbarItem(placement: .cancellationAction) {
                    
                    // Closes this view without saving
                    Button("Cancel") {
                        dismiss()
                    }
                }
                // Save button on the right side of the nav bar
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Calls function to save the new user

                        saveUser()
                    }
                    // Disable save button if userName is empty or just whitespace
                    .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    // Private function to save the new user to the database
    private func saveUser() {
        let trimmedName = userName.trimmingCharacters(in: .whitespaces)
        // Guard statement exits early if name is empty
        guard !trimmedName.isEmpty else { return }
        
        // Create a new User object with the trimmed name
        let newUser = User(name: trimmedName)
        // Insert the new user into SwiftData's context (stages it for saving)
        modelContext.insert(newUser)
        // Close this view - SwiftData automatically saves when context changes
        dismiss()
    }
}

