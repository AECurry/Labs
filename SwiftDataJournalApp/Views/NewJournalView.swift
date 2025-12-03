//
//  JournalsView.swift
//  SwiftDataJournalApp
//
//  Created by AnnElaine on 12/3/25.
//

import SwiftUI
import SwiftData

// Helper: Creates SwiftUI Colors from hex color codes like "#FF3B30"
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)  // RGB
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)  // ARGB
        default: (a, r, g, b) = (255, 0, 0, 0)  // Default: black
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Modal form for creating a new journal for a specific user
struct NewJournalView: View {  // ✅ Renamed from AddJournalView
    let user: User                    // User who will own this new journal
    @Environment(\.modelContext) private var modelContext  // For saving to database
    @Environment(\.dismiss) private var dismiss            // To close this modal view
    
    @State private var journalTitle = ""      // User's input for journal name
    @State private var selectedColor = "#007AFF"  // Currently selected color
    let colors = ["#FF3B30", "#FF9500", "#FFCC00", "#34C759",
                  "#007AFF", "#5856D6", "#AF52DE"]  // Available color options
    
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
            }
            .navigationTitle("New Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button (left side)
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                // Save button (right side) - disabled if title is empty
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveJournal() }
                        .disabled(journalTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    // Saves the new journal to the database
    private func saveJournal() {
        let trimmedTitle = journalTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }
        
        // Create and save the new journal
        let newJournal = Journal(title: trimmedTitle, user: user, color: selectedColor)
        modelContext.insert(newJournal)  // Add to database
        dismiss()  // Close the modal view
    }
}

