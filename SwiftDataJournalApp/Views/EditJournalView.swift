//
//  EditJournalView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/3/25.
//

import SwiftUI
import SwiftData

// Modal form for editing a journal's properties (color and title)
struct EditJournalView: View {
    let journal: Journal                    // The journal being edited
    @Environment(\.modelContext) private var modelContext  // For saving changes
    @Environment(\.dismiss) private var dismiss            // To close this modal
    
    @State private var journalTitle: String    // Editable journal title
    @State private var selectedColor: String   // Currently selected color
    let colors = ["#FF3B30", "#FF9500", "#FFCC00", "#34C759",
                  "#007AFF", "#5856D6", "#AF52DE"]  // Available color options
    
    init(journal: Journal) {
        self.journal = journal
        // Initialize state with current journal values
        _journalTitle = State(initialValue: journal.title)
        _selectedColor = State(initialValue: journal.color)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Journal name input field
                TextField("Journal Title", text: $journalTitle)
                
                // Color selection section
                Section("Journal Color") {
                    HStack {
                        // Display all color options as selectable circles
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(hex: color))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    // Highlight selected color with border
                                    Circle()
                                        .stroke(Color.primary, lineWidth: selectedColor == color ? 2 : 0)
                                )
                                .onTapGesture { selectedColor = color }  // Select on tap
                                .padding(2)
                        }
                    }
                }
                
                // Danger zone section for deleting the journal
                Section {
                    Button(role: .destructive) {
                        deleteJournal()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Journal")
                        }
                    }
                } header: {
                    Text("Danger Zone")
                } footer: {
                    Text("Deleting this journal will also delete all \(journal.entries.count) entries inside it.")
                }
            }
            .navigationTitle("Edit Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button (left side)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                // Save button (right side) - disabled if title is empty
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .disabled(journalTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    // Saves the updated journal properties to the database
    private func saveChanges() {
        let trimmedTitle = journalTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }
        
        // Update the journal's properties
        journal.title = trimmedTitle
        journal.color = selectedColor
        
        do {
            try modelContext.save()  // Save changes to database
            dismiss()  // Close the modal view
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    // Deletes the entire journal and all its entries
    private func deleteJournal() {
        modelContext.delete(journal)  // Cascade delete will also delete all entries
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Delete failed: \(error)")
        }
    }
}

