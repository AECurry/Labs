//
//  EmojiListView.swift
//  EmojiDictionary
//
//  Created by AnnElaine Curry on 10/30/25.
//

import SwiftUI

/**
 The main view that displays the list of emojis and handles user interactions.
 
 This view serves as the primary interface for browsing, adding, editing,
 and managing emojis in the dictionary. It includes full CRUD (Create, Read,
 Update, Delete) operations with persistent storage.
 */
struct EmojiListView: View {
    
    // MARK: - State Properties
    
    /// The main collection of emoji objects displayed in the list
    @State private var emojis: [Emoji] = []
    
    /// Controls whether the add/edit sheet is presented
    @State private var isShowingAddEdit = false
    
    /// The emoji currently being edited, or nil when adding a new one
    @State private var editingEmoji: Emoji? = nil
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Emoji List Content
                ForEach(emojis) { emoji in
                    // Each emoji in the list is a button that triggers edit mode
                    Button {
                        // Set the current emoji for editing and show the sheet
                        editingEmoji = emoji
                        isShowingAddEdit = true
                    } label: {
                        // Display the emoji using the custom row view
                        EmojiRow(emoji: emoji)
                    }
                    .buttonStyle(.plain) // Use plain style to avoid default button styling
                }
                // MARK: - List Modifiers
                .onDelete { indices in
                    // Handle swipe-to-delete gesture
                    emojis.remove(atOffsets: indices)
                    // Persist the changes immediately
                    Emoji.saveToFile(emojis: emojis)
                }
                .onMove { indices, newOffset in
                    // Handle drag-to-reorder gesture
                    emojis.move(fromOffsets: indices, toOffset: newOffset)
                    // Persist the new order immediately
                    Emoji.saveToFile(emojis: emojis)
                }
            }
            // MARK: - Navigation & Toolbar
            .navigationTitle("Emoji Dictionary")
            .toolbar {
                // Add button in the top-right navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        // Clear any editing context and show add sheet
                        editingEmoji = nil
                        isShowingAddEdit = true
                    }
                }
                // Edit button for reordering (automatically provided by SwiftUI)
                // Delete functionality is provided via swipe gestures
            }
            // MARK: - Sheets & Modals
            .sheet(isPresented: $isShowingAddEdit) {
                // Present the add/edit form as a sheet
                AddEditEmojiView(emoji: editingEmoji) { result in
                    // Handle the result when user saves in the sheet
                    handleSaveResult(result)
                }
            }
            // MARK: - Lifecycle
            .onAppear {
                // Load data when the view first appears
                loadEmojis()
            }
        }
    }
    
    // MARK: - Private Methods
    
    /**
     Handles the save operation from the AddEditEmojiView.
     
     This method determines whether to update an existing emoji or add a new one
     based on whether the emoji ID already exists in the collection.
     
     - Parameter result: The emoji object returned from the add/edit form
     */
    private func handleSaveResult(_ result: Emoji) {
        // Check if this is an edit operation (emoji already exists)
        if let index = emojis.firstIndex(where: { $0.id == result.id }) {
            // Update existing emoji at found index
            emojis[index] = result
        } else {
            // Add new emoji to the collection
            emojis.append(result)
        }
        
        // Persist the changes to disk
        Emoji.saveToFile(emojis: emojis)
        
        // Dismiss the sheet
        isShowingAddEdit = false
    }
    
    /**
     Loads emoji data from persistent storage with intelligent fallback logic.
     
     This method attempts to load previously saved emojis and includes sophisticated
     logic to handle different scenarios:
     - Successful file load: Uses saved data
     - First app launch: Uses sample data and saves it immediately
     - Corrupted file: Starts with empty array
     
     The key improvement is that sample data is only used once on first launch,
     preventing the sample emojis from reappearing on subsequent app launches.
     */
    private func loadEmojis() {
        if let loadedEmojis = Emoji.loadFromFile() {
            // Successfully loaded saved emojis from file
            emojis = loadedEmojis
        } else {
            // File loading failed - determine the specific scenario
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: Emoji.archiveURL.path) {
                // Scenario 1: First app launch - no file exists yet
                emojis = Emoji.sampleEmojis()
                Emoji.saveToFile(emojis: emojis)
            } else {
                // Scenario 2: File exists but is corrupted/unreadable - start fresh
                emojis = []
            }
        }
    }
}

// MARK: - Supporting Views

/**
 A custom view that displays a single emoji in the list row.
 
 This view defines the layout and styling for how each emoji appears
 in the main list, showing the symbol, name, and description.
 */
struct EmojiRow: View {
    
    /// The emoji data to display in this row
    let emoji: Emoji
    
    var body: some View {
        HStack {
            // Emoji symbol - displayed large for visibility
            Text(emoji.symbol)
                .font(.largeTitle)
            
            // Text information in a vertical stack
            VStack(alignment: .leading) {
                // Emoji name - prominent display
                Text(emoji.name)
                    .font(.headline)
                
                // Emoji description - secondary information
                Text(emoji.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer() // Push content to the left, standard iOS list behavior
        }
        .padding(.vertical, 4) // Add vertical padding for better touch targets
    }
}

// MARK: - Previews

/**
 Xcode preview for development and testing.
 
 This preview allows developers to see the EmojiListView in Xcode's canvas
 without running the entire app. It uses sample data for display.
 */
#Preview {
    EmojiListView()
    // Example of preview modifications that could be added:
    // .environment(\.locale, .init(identifier: "es")) // Test localization
    // .environment(\.sizeCategory, .accessibilityLarge) // Test dynamic type
}

#Preview("Dark Mode") {
    EmojiListView()
        .preferredColorScheme(.dark) // Test dark mode appearance
}

#Preview("Empty State") {
    EmojiListView()
    // This would need a custom initializer for empty state testing
}

