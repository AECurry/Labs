//
//  JournalEntryDetailView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/2/25.
//

import SwiftUI
import SwiftData

// View for creating or editing a journal entry
struct JournalEntryDetailView: View {
    // Database access for saving data
    @Environment(\.modelContext) private var modelContext
    
    // Closes the view (sheet or navigation)
    @Environment(\.dismiss) private var dismiss
    
    // The journal this entry belongs to (nil when editing)
    let journal: Journal?
    
    // The entry being edited (nil when creating new)
    let entry: JournalEntry?
    
    // Form fields - separate from database until saved
    @State private var title: String = ""
    @State private var bodyText: String = ""
    
    // Supports both modes: create (journal provided) or edit (entry provided)
    init(journal: Journal? = nil, entry: JournalEntry? = nil) {
        self.journal = journal
        self.entry = entry
    }
    
    var body: some View {
        Form {
            // Entry title input
            TextField("Title", text: $title)
            
            // Entry content input
            TextEditor(text: $bodyText)
                .frame(height: 200)
        }
        .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
        .toolbar {
            
            // Save to database
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveEntry() }
                    // Prevent saving empty titles
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear {
            // Pre-fill form when editing existing entry
            if let entry = entry {
                title = entry.title
                bodyText = entry.body
            }
        }
    }
    
    // Handles saving both new and edited entries
    private func saveEntry() {
        // Edit mode: update existing entry
        if let entry = entry {
            entry.title = title
            entry.body = bodyText
        }
        // Create mode: make new entry linked to journal
        else if let journal = journal {
            let newEntry = JournalEntry(title: title, body: bodyText, journal: journal)
            modelContext.insert(newEntry)
        }
        
        // Save changes to database
        do {
            // Close view on success
            try modelContext.save()
            dismiss()
        } catch {
            // In production: show error alert to user
            print("Save failed: \(error)")
            
        }
    }
}

