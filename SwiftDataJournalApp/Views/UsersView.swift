//
//  UsersView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/2/25.
//

import SwiftUI
import SwiftData

// The main/root view of the app - shows list of all users
struct UsersView: View {
    // Access to SwiftData context for deleting users
    @Environment(\.modelContext) private var modelContext
    
    // @Query automatically fetches all User objects from the database
    // Sorted by creation date, oldest first (.forward)
    @Query(sort: \User.createdAt, order: .forward) private var users: [User]
    
    // State variable to control whether the "Add User" sheet is showing
    @State private var showingAddUser = false
    
    var body: some View {
        // NavigationStack is required for navigation and toolbar
        NavigationStack {
            // List displays all users in a scrollable list
            List {
                // ForEach creates a row for each user
                ForEach(users) { user in
                    // NavigationLink makes row tappable and navigates to journal list
                    NavigationLink {
                        // Destination: show this user's journal entries
                        JournalsView(user: user)
                        
                    } label: {
                        // Display the user's name in the row
                        Text(user.name)
                    }
                    
                }
                
                // Enable swipe-to-delete on user rows
                .onDelete { indexSet in
                    for index in indexSet {
                        // Delete the user (cascade rule will also delete their entries)
                        modelContext.delete(users[index])
                    }
                    // Save the deletion to disk
                    do {
                        try modelContext.save()
                    } catch {
                        print("Delete save failed: \(error)")
                    }
                }
            }
                .navigationTitle("Users")  // Title at the top
                .toolbar {
                    // Plus button in top-right corner
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button {
                            // Show the "Add User" sheet when tapped
                            showingAddUser = true
                        } label: {
                            Image(systemName: "plus")  // SF Symbol plus icon
                        }
                    }
                }
                // .sheet presents a modal view that slides up from bottom
                // isPresented is bound to showingAddUser state
                .sheet(isPresented: $showingAddUser) {
                    // The view to show in the sheet
                    AddUserView()
            }
        }
    }
}

