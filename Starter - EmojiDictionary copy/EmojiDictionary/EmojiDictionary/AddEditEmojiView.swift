//
//  AddEditEmojiView.swift
//  EmojiDictionary
//
//  Created by AnnElaine Curry on 10/30/25.
//

import SwiftUI

/**
 A view for adding new emojis or editing existing ones.
 
 This view presents a form with text fields for emoji properties and handles both creation of new emojis and modification of existing ones.
 */
struct AddEditEmojiView: View {
    
    // MARK: - Environment Properties
    /// Dismiss action to close the sheet when done
    @Environment(\.dismiss) var dismiss
    
    // MARK: - State Properties
    /// The emoji character/symbol (e.g., "😀")
    @State var symbol: String
    /// The name of the emoji (e.g., "Grinning Face")
    @State var name: String
    /// A description of what the emoji represents
    @State var description: String
    /// Common usage contexts for the emoji
    @State var usage: String
    
    // MARK: - Regular Properties
    /// The emoji being edited, or nil if creating a new one
    var emojiToEdit: Emoji?
    /// Closure called when the user taps Save, passing the new or modified emoji
    var onSave: (Emoji) -> Void
    
    // MARK: - Initializer
    /**
     Initializes the view for either adding a new emoji or editing an existing one.
     
     - Parameters:
        - emoji: The emoji to edit, or nil to create a new one
        - onSave: Closure called when saving, receives the completed Emoji object
     */
    init(emoji: Emoji?, onSave: @escaping (Emoji) -> Void) {
        // Initialize state properties with existing emoji values or empty strings
        // Using underscore to access the State wrapper directly
        _symbol = State(initialValue: emoji?.symbol ?? "")
        _name = State(initialValue: emoji?.name ?? "")
        _description = State(initialValue: emoji?.description ?? "")
        _usage = State(initialValue: emoji?.usage ?? "")
        
        // Store the emoji being edited and the save callback
        self.emojiToEdit = emoji
        self.onSave = onSave
    }
    
    // MARK: - Computed Properties
    /**
     Validates whether all form fields contain non-empty values.
     
     - Returns: True if all fields have content, false otherwise
     */
    var isFormValid: Bool {
        // Check that all required fields are filled out
        !symbol.isEmpty &&
        !name.isEmpty &&
        !description.isEmpty &&
        !usage.isEmpty
    }
    
    /**
     Determines the appropriate title based on whether we're adding or editing.
     
     - Returns: "Add Emoji" for new emojis, "Edit Emoji" for existing ones
     */
    var navigationTitle: String {
        emojiToEdit == nil ? "Add Emoji" : "Edit Emoji"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // MARK: - Form Sections
                // Emoji symbol input field
                TextField("Emoji", text: $symbol)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
                // Emoji name input field
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)
                
                // Emoji description input field
                TextField("Description", text: $description)
                    .textInputAutocapitalization(.sentences)
                
                // Emoji usage input field
                TextField("Usage", text: $usage)
                    .textInputAutocapitalization(.sentences)
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                // MARK: - Toolbar Items
                
                // Save button - appears on the trailing side (right for LTR languages)
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEmoji()
                    }
                    .disabled(!isFormValid) // Disable if form is incomplete
                }
                
                // Cancel button - appears on the leading side (left for LTR languages)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // Simply close the sheet without saving
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    /**
     Handles the save action when the user taps the Save button.
     
     This method creates a new Emoji object (or updates the existing one),
     calls the onSave closure with the result, and dismisses the view.
     */
    private func saveEmoji() {
        // Create a new Emoji object:
        // - Use existing ID if editing, generate new UUID if creating
        // - Use current values from the form fields
        let emoji = Emoji(
            id: emojiToEdit?.id ?? UUID(), // Preserve ID when editing
            symbol: symbol,
            name: name,
            description: description,
            usage: usage
        )
        
        // Notify the parent view about the saved emoji
        onSave(emoji)
        
        // Close the sheet
        dismiss()
    }
}

// MARK: - Preview
/**
 Provides a preview of the view in Xcode's canvas.
 
 Shows both Add and Edit modes for development and testing.
 */
#Preview("Add Emoji Mode") {
    AddEditEmojiView(emoji: nil) { emoji in
        print("Preview: Would save new emoji - \(emoji.name)")
    }
}

#Preview("Edit Emoji Mode") {
    let sampleEmoji = Emoji(
        symbol: "😀",
        name: "Grinning Face",
        description: "A typical smiley face",
        usage: "happiness"
    )
    
    return AddEditEmojiView(emoji: sampleEmoji) { emoji in
        print("Preview: Would save edited emoji - \(emoji.name)")
    }
}
