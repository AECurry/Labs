//
//  JournalEntriesView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/3/25.
//

import SwiftUI
import SwiftData

// Shows all journal entries for a specific journal
struct JournalEntriesView: View {
    let journal: Journal              // The specific journal we're viewing entries for
    @Environment(\.modelContext) private var modelContext  // For database operations
    
    // Automatically fetches and monitors entries from the database
    // Filtered to show only entries belonging to this journal
    @Query private var entries: [JournalEntry]
    
    @State private var showingEditJournal = false  // Controls the journal edit sheet
    
    init(journal: Journal) {
        self.journal = journal
        let journalId = journal.persistentModelID  // Get unique ID for filtering
        
        // Configure the query: filter entries by journal ID, sort newest first
        _entries = Query(
            filter: #Predicate<JournalEntry> { entry in
                entry.journal?.persistentModelID == journalId
            },
            sort: \.createdDate,
            order: .reverse  // Newest entries appear first at top
        )
    }
    
    var body: some View {
        List {
            // Display each entry as a tappable row
            ForEach(entries) { entry in
                NavigationLink {
                    // Go to edit view when an entry is tapped
                    JournalEntryDetailView(journal: journal, entry: entry)
                } label: {
                    VStack(alignment: .leading) {
                        Text(entry.title)
                            .font(.headline)  // Bold title
                        Text(entry.createdDate, style: .date)  // Auto-formatted date
                            .font(.caption)   // Small text
                            .foregroundColor(.gray)  // Subtle color
                    }
                }
            }
            // Enable swipe-to-delete gesture on entries
            .onDelete { indexSet in
                for index in indexSet {
                    let entry = entries[index]
                    modelContext.delete(entry)  // Mark entry for deletion
                }
                do {
                    try modelContext.save()  // Save deletion to database
                } catch {
                    print("Delete failed: \(error)")
                }
            }
        }
        .navigationTitle(journal.title)  // Shows the journal's name as screen title
        .toolbar {
            // Edit button on left - edits THIS JOURNAL's properties
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Edit") {
                    showingEditJournal = true  // Show edit sheet
                }
            }
            
            // Plus button on right - creates NEW ENTRY in this journal
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    // Create mode: pass journal but no entry (nil)
                    JournalEntryDetailView(journal: journal)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // Modal sheet for editing journal properties (color, title)
        .sheet(isPresented: $showingEditJournal) {
            EditJournalView(journal: journal)
        }
    }
}

