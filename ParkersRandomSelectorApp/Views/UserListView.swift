//
//  UserListView.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

// DUMB CHILD VIEW - Only displays data and sends events up to parent
import SwiftUI

struct UserListView: View {
    // Data received from parent
    let users: [User]
    let selectedUsers: Set<User>
    
    // Callbacks to parent
    let onDelete: (User) -> Void
    let onMove: (IndexSet, Int) -> Void
    let onEdit: (User, String) -> Void
    
    // Local state for edit alert
    @State private var editingUser: User?
    @State private var editedName = ""
    
    var body: some View {
        List {
            ForEach(users) { user in
                HStack {
                    Text(user.name)
                        .foregroundColor(selectedUsers.contains(user) ? .green : .primary)
                    
                    Spacer()
                    
                    // Checkmark indicator for selected users
                    if selectedUsers.contains(user) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal, 16)
                // Swipe actions for edit/delete
                .swipeActions(edge: .trailing) {
                    // Delete button (red)
                    Button(role: .destructive) {
                        onDelete(user)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    // Edit button (blue)
                    Button {
                        editingUser = user
                        editedName = user.name
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
            .onMove(perform: onMove) // Drag to reorder
        }
        .listStyle(.plain)
        .padding(.top, 16)
        // Edit name alert
        .alert("Edit Name", isPresented: .constant(editingUser != nil)) {
            TextField("Name", text: $editedName)
                .textInputAutocapitalization(.words)
            Button("Cancel") {
                editingUser = nil
            }
            Button("Save") {
                if let user = editingUser {
                    onEdit(user, editedName)
                }
                editingUser = nil
            }
        }
    }
}
