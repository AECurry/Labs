//
//  SelectPlayersSheet.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//
//

// Player selection modal/sheet for game/team creation
import SwiftUI
import SwiftData

// ====================================================
// Player Selection Row Component (Reusable View Component)
// ====================================================

struct PlayerSelectionRow: View {
    
    // Data Input (Dependency Injection)
    let student: Student          // The player data model (immutable)
    let isSelected: Bool         // Selection state (true = selected)
    let maxReached: Bool         // UI feedback when selection limit reached
    
    // View Body
    var body: some View {

        HStack(spacing: 16) {
            
// ====================================================
// 1. SELECTION INDICATOR (Left-most element)
// ====================================================
            ZStack {
                Circle()
                    .stroke(
                        isSelected ? Color.fnBlue : Color.fnGray1, // Blue when selected, gray otherwise
                        lineWidth: 2
                    )
                    .frame(width: 24, height: 24)
                
                // Inner fill circle (only when selected)
                if isSelected {
                    Circle()
                        .fill(Color.fnBlue)
                        .frame(width: 14, height: 14)
                }
            }
// ====================================================
// 2. PLAYER AVATAR / PROFILE IMAGE
// ====================================================
            Circle()
                .fill(student.skillLevel.color) // Dynamic color based on skill level
                .frame(width: 44, height: 44)   // Standard avatar size
                .overlay(
                    Text(String(student.name.prefix(1))) // Display first initial
                        .font(.headline)
                        .foregroundColor(.fnWhite)
                )
// ====================================================
// 3. PLAYER INFORMATION SECTION
// ====================================================
            VStack(alignment: .leading, spacing: 4) {
                // Player Name (Primary information)
                Text(student.name)
                    .font(.headline)
                    .foregroundColor(.fnWhite)
                
                // Metadata Row (Secondary information)
                HStack(spacing: 8) {
                    // Grade Level
                    Text("Grade \(student.grade)")
                        .font(.caption)
                        .foregroundColor(.fnWhite)
                    
                    // Separator
                    Text("•")
                        .foregroundColor(.fnWhite)
                    
                    // Skill Level with Icon
                    HStack(spacing: 4) {
                        Image(systemName: student.skillLevel.icon) // SF Symbol based on skill
                            .font(.caption2)
                        Text(student.skillLevel.rawValue) // Skill level text
                            .font(.caption)
                    }
                    .foregroundColor(student.skillLevel.color) // Color matches skill
                }
            }
// ====================================================
// 4. SPACER (Push content left, lock icon right)
// ====================================================
            Spacer()
// ====================================================
// 5. LOCK ICON (Conditional visual feedback)
// ====================================================
            if maxReached && !isSelected {
                Image(systemName: "lock.fill")
                    .foregroundColor(.fnGray1) // Gray indicates disabled state
                    .font(.caption)
            }
            // Purpose: Visual cue that player cannot be selected (limit reached)
        }
// ====================================================
// 6. ROW STYLING (Applied to entire HStack)
// ====================================================
        .padding() // Internal padding for touch target and visual spacing
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    isSelected ?
                    Color.fnBlue.opacity(0.2) :      // Light blue background when selected
                    Color.fnGray2.opacity(0.5)       // Gray background when not selected
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected ? Color.fnBlue : Color.clear, // Blue border when selected
                    lineWidth: 2
                )
        )
    }
}
// ====================================================
// Main Select Players Sheet (Modal/Full Screen View)
// ====================================================

struct SelectPlayersSheet: View {
    
    @Environment(\.dismiss) private var dismiss

    // Input Properties (Passed from parent view)
    let title: String               // Sheet title (e.g., "Select Players for Team 1")
    @Binding var selectedPlayers: [Student] // Two-way binding for selection state
    let teamNumber: Int             // Team identifier (for display purposes)
    let requiredCount: Int          // Number of players required
    let availableStudents: [Student] // List of all selectable players
    
    // Local State (Sheet-specific state)
    @State private var searchText = "" // Search query for filtering
    
    // Computed Properties (Derived Data)
    
    var filteredStudents: [Student] {
        // Step 1: Filter to only active students
        let activeStudents = availableStudents.filter { $0.isActive }
        
        // Step 2: Apply search filter if text exists
        if searchText.isEmpty {
            return activeStudents // Return all if no search
        } else {
            return activeStudents.filter { student in
                // Case-insensitive search in name OR student ID
                student.name.localizedCaseInsensitiveContains(searchText) ||
                student.studentID.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // Main View Body
    var body: some View {
        // Navigation wrapper for toolbar and title
        NavigationStack {
            ZStack { // ZStack for background layering
// ====================================================
// 1. BACKGROUND LAYER
// ====================================================
                Color(red: 0.08, green: 0.0, blue: 0.15) // Custom dark purple
                    .ignoresSafeArea() // Fill entire screen
// ====================================================
// 2. CONTENT LAYER (Foreground)
// ====================================================
                VStack(spacing: 0) { // Vertical stack with no spacing between sections
                    
                    // Header Section (Selection progress)
                    headerSection
                        .background(Color(red: 0.08, green: 0.0, blue: 0.15))
                    
                    // Search Bar
                    searchBar
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                        .background(Color(red: 0.08, green: 0.0, blue: 0.15))
                    
                    // Players List or Empty State
                    if availableStudents.isEmpty {
                        emptyStateView // Show when no players available
                    } else {
                        playersList // Show list of players
                    }
                }
            }
// ====================================================
// 3. NAVIGATION CONFIGURATION
// ====================================================
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color(red: 0.08, green: 0.0, blue: 0.15),
                for: .navigationBar
            ) // <-- Set the nav bar background to your dark purple
            .toolbarBackground(.visible, for: .navigationBar) // <-- Make sure it's visible
            .toolbar {
                // Done Button (Top-left action)
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") {
                        dismiss() // Close the modal sheet
                    }
                    .foregroundColor(.fnWhite)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
// View Components (Extracted for Readability)
    /**
     Header section showing selection requirements and progress.
     */
    private var headerSection: some View {
        VStack(spacing: 8) {
            // Instruction text
            Text("Select \(requiredCount) player(s)")
                .font(.subheadline)
                .foregroundColor(.fnGray3) // Secondary text color
            
            // Progress indicator (selected/total)
            Text("\(selectedPlayers.count)/\(requiredCount) selected")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(
                    selectedPlayers.count == requiredCount ?
                    .fnGreen : .fnBlue // Green when complete, blue otherwise
                )
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule() // Pill-shaped background
                        .fill(
                            selectedPlayers.count == requiredCount ?
                            Color.fnGreen.opacity(0.2) : // Light green when complete
                            Color.fnBlue.opacity(0.2)    // Light blue when incomplete
                        )
                )
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity) // Full width
    }
    
    /**
     Search bar with clear button functionality.
     */
    private var searchBar: some View {
        HStack {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.fnWhite)
            
            // Text input field
            TextField("Search players...", text: $searchText)
                .foregroundColor(Color.fnWhite)
                .autocorrectionDisabled() // Disable autocorrect for names/IDs
            
            // Clear button (conditional)
            if !searchText.isEmpty {
                Button {
                    searchText = "" // Clear search text
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.fnGray1)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.fnGray3.opacity(0.3)) // Semi-transparent background
        .cornerRadius(10)
    }
    
    /**
     Scrollable list of players with selection functionality.
     */
    private var playersList: some View {
        ScrollView {
            LazyVStack(spacing: 12) { // Lazy loading for performance
                ForEach(filteredStudents) { student in
                    Button {
                        toggleSelection(for: student) // Handle selection
                    } label: {
                        // Use the reusable row component
                        PlayerSelectionRow(
                            student: student,
                            isSelected: isSelected(student),
                            maxReached: selectedPlayers.count >= requiredCount && !isSelected(student)
                        )
                    }
                    .buttonStyle(.plain) // Remove default button styling
                    .disabled( // Disable button when:
                        selectedPlayers.count >= requiredCount && // Limit reached AND
                        !isSelected(student) // Player not already selected
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    /**
     Empty state view when no players are available.
     */
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Illustration icon
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.fnGray1)
                .opacity(0.5)
            
            // Primary message
            Text("No Players Available")
                .font(.title2)
                .foregroundColor(.fnWhite)
                .fontWeight(.semibold)
            
            // Secondary instruction
            Text("Add players in the Players tab first")
                .font(.body)
                .foregroundColor(.fnGray1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
// Helper Methods (Business Logic)
// Checks if a student is currently selected.
    
    private func isSelected(_ student: Student) -> Bool {
        selectedPlayers.contains(where: { $0.id == student.id })
    }
    
    /**
     Toggles selection state for a student.
     
     Business Rules:
     1. If already selected → remove from selection
     2. If not selected AND under limit → add to selection
     3. If not selected AND at limit → no action
     */
    
    private func toggleSelection(for student: Student) {
        if isSelected(student) {
            // Deselect: Remove from array
            selectedPlayers.removeAll { $0.id == student.id }
        } else if selectedPlayers.count < requiredCount {
            // Select: Add to array (if under limit)
            selectedPlayers.append(student)
        }
        // Note: No else case needed - button is disabled when limit reached
    }
}

