//
//  RandomSelectorViewModel.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

import Foundation
import SwiftData
import Observation
import SwiftUI

@Observable // Allows SwiftUI to watch for changes to any property
final class RandomSelectorViewModel {
    // MARK: - Published Properties
    var modelContext: ModelContext? // Connection to SwiftData
    var users: [User] = []          // Array of all users
    var selectionCount: Int = 1     // Number of users to select (1-8)
    var selectedUsers: Set<User> = [] // Currently selected users
    var isAnimating = false          // Controls selection animation
    var errorMessage: String?        // Error alerts
    var showAddUserSheet = false     // Controls add user sheet
    var newUserName = ""             // Temporary storage for new user input
    var showResultsPopup = false     // Controls results popup
    
    // MARK: - Setup
    func setup(with context: ModelContext) {
        self.modelContext = context
        fetchUsers()
        loadSelectionCount()
    }
    
    // MARK: - User Management
    func fetchUsers() {
        do {
            // Fetch all users sorted by creation date (preserves custom order)
            let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.createdAt)])
            users = try (modelContext?.fetch(descriptor)) ?? []
        } catch {
            errorMessage = "Failed to fetch users"
        }
    }
    
    func addUser() {
        let trimmedName = newUserName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validation
        guard !trimmedName.isEmpty else {
            errorMessage = "Name cannot be empty"
            return
        }
        
        guard !users.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            errorMessage = "User already exists"
            return
        }
        
        // Create and save new user
        let user = User(name: trimmedName)
        modelContext?.insert(user)
        saveContext()
        fetchUsers()
        
        // Reset form
        newUserName = ""
        showAddUserSheet = false
    }
    
    func deleteUser(_ user: User) {
        modelContext?.delete(user)
        saveContext()
        fetchUsers()
        selectedUsers.remove(user) // Remove from selection if selected
    }
    
    func updateUserName(_ user: User, newName: String) {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validation
        guard !trimmedName.isEmpty else {
            errorMessage = "Name cannot be empty"
            return
        }
        
        // Check for duplicates (excluding current user)
        guard !users.contains(where: { $0.name.lowercased() == trimmedName.lowercased() && $0.id != user.id }) else {
            errorMessage = "User '\(trimmedName)' already exists"
            return
        }
        
        user.name = trimmedName
        saveContext()
        fetchUsers()
    }
    
    // MARK: - Reordering
    func moveUsers(from source: IndexSet, to destination: Int) {
        var updatedUsers = users
        updatedUsers.move(fromOffsets: source, toOffset: destination)
        
        // Update timestamps to reflect new order (sorting uses createdAt)
        for (index, user) in updatedUsers.enumerated() {
            user.createdAt = Date().addingTimeInterval(TimeInterval(index))
        }
        
        saveContext()
        fetchUsers()
    }
    
    // MARK: - Selection Logic
    func updateSelectionCount(_ newCount: Int) {
        // Limit to max 8 and never exceed user count
        selectionCount = min(max(newCount, 1), min(users.count, 8))
        saveSelectionCount()
    }
    
    func performRandomSelection() -> [User] {
        guard !users.isEmpty else {
            errorMessage = "No users to select from"
            return []
        }
        
        // Shuffle and pick first 'selectionCount' users
        let shuffled = users.shuffled()
        let selected = Array(shuffled.prefix(selectionCount))
        selectedUsers = Set(selected) // Store in Set for O(1) lookup
        return selected
    }
    
    func clearSelection() {
        selectedUsers.removeAll()
    }
    
    // MARK: - Persistence Helpers
    private func saveContext() {
        try? modelContext?.save() // Save changes to SwiftData
    }
    
    private func loadSelectionCount() {
        selectionCount = UserDefaults.standard.integer(forKey: "selectionCount")
        if selectionCount < 1 || selectionCount > 8 {
            selectionCount = 1 // Default if invalid
        }
    }
    
    private func saveSelectionCount() {
        UserDefaults.standard.set(selectionCount, forKey: "selectionCount")
    }
}
