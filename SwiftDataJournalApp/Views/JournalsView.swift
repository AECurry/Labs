//
//  JournalsView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/3/25.
//

import SwiftUI
import SwiftData

// Shows all journals for a specific user
struct JournalsView: View {
    let user: User                      // The user whose journals we're showing
    @Environment(\.modelContext) private var modelContext  // For database operations
    
    // Automatically fetches and monitors journals from database
    // Filtered to show only journals belonging to this user
    @Query private var journals: [Journal]
    
    @State private var showingNewJournal = false  // Controls the "new journal" modal sheet
    
    init(user: User) {
        self.user = user
        let userId = user.persistentModelID  // Get unique ID for filtering
        
        // Configure query: filter journals by user ID, sort newest first
        _journals = Query(
            filter: #Predicate<Journal> { journal in
                journal.user?.persistentModelID == userId
            },
            sort: \.createdAt,
            order: .reverse  // Newest journals appear first at top
        )
    }
    
    var body: some View {
        List {
            // Display each journal as a tappable row
            ForEach(journals) { journal in
                NavigationLink(destination: JournalEntriesView(journal: journal)) {
                    HStack {
                        // Color-coded dot for visual identification
                        Circle()
                            .fill(Color(hex: journal.color))
                            .frame(width: 12, height: 12)
                        
                        // Journal name/title
                        Text(journal.title)
                        
                        Spacer()
                        
                        // Show entry count for this journal
                        Text("\(journal.entries.count)")
                            .font(.caption)   // Smaller text
                            .foregroundColor(.gray)  // Subtle color
                    }
                }
                .padding(.vertical, 4)  // Add vertical spacing between rows
            }
            // Enable swipe-to-delete gesture for journals
            .onDelete { indexSet in
                for index in indexSet {
                    // Delete the journal (cascade rule will also delete all its entries)
                    modelContext.delete(journals[index])
                }
                // Save the deletion to the database
                do {
                    try modelContext.save()
                } catch {
                    print("Delete failed: \(error)")
                }
            }
        }
        .navigationTitle("\(user.name)'s Journals")  // Dynamic title with user's name
        .toolbar {
            // Plus button in top-right corner for creating new journals
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingNewJournal = true  // Show the "new journal" modal
                } label: {
                    Image(systemName: "plus")  // SF Symbol plus icon
                }
            }
        }
        // Modal sheet for creating a new journal
        // isPresented is bound to showingNewJournal state
        .sheet(isPresented: $showingNewJournal) {
            // The view to show in the sheet - creates a new journal
            NewJournalView(user: user)
        }
    }
}

