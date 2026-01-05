//
//  TeamSelectorView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData

struct TeamSelectorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(
        filter: #Predicate<Student> { $0.isActive == true },
        sort: \Student.name
    ) private var activeStudents: [Student]
    
    @State private var searchText = ""
    @State private var selectedPlayerIDs: Set<Student.ID> = []
    
    let teamName: String
    let maxSelections: Int = 1
    
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return activeStudents
        } else {
            return activeStudents.filter { student in
                student.name.localizedCaseInsensitiveContains(searchText) ||
                student.studentID.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background matching your app theme
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Section - matches your screenshot
                    headerSection
                    
                    // Search Bar
                    searchSection
                    
                    // Players List
                    playersListSection
                    
                    // Selected Players (if any)
                    selectedPlayersSection
                }
            }
            .navigationTitle("Select Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.fnWhite)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveSelectionAndDismiss()
                    }
                    .foregroundColor(canSave ? .fnBlue : .fnGray1)
                    .disabled(!canSave)
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(teamName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.fnWhite)
            
            Text("Select \(maxSelections) player(s)")
                .font(.subheadline)
                .foregroundColor(.fnGray1)
            
            Text("\(selectedPlayerIDs.count)/\(maxSelections) selected")
                .font(.caption)
                .foregroundColor(selectedPlayerIDs.count == maxSelections ? .fnGreen : .fnGold)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(selectedPlayerIDs.count == maxSelections ?
                              Color.fnGreen.opacity(0.2) : Color.fnGold.opacity(0.2))
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.fnBlack.opacity(0.3))
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.fnGray1)
                .padding(.leading, 8)
            
            TextField("Q Search players", text: $searchText)
                .foregroundColor(.fnWhite)
                .padding(.vertical, 10)
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.fnGray1)
                        .padding(.trailing, 8)
                }
            }
        }
        .background(Color.fnGray2)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    private var playersListSection: some View {
        Group {
            if filteredStudents.isEmpty {
                if activeStudents.isEmpty {
                    return AnyView(emptyStateNoPlayers)
                } else {
                    return AnyView(emptyStateNoSearchResults)
                }
            } else {
                return AnyView(
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredStudents) { student in
                                PlayerSelectionCell(
                                    student: student,
                                    isSelected: selectedPlayerIDs.contains(student.id),
                                    maxReached: selectedPlayerIDs.count >= maxSelections,
                                    onSelect: { toggleSelection(for: student) }
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                )
            }
        }
    }
    
    private var selectedPlayersSection: some View {
        Group {
            if !selectedPlayerIDs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(Color.fnGray2)
                        .padding(.horizontal)
                    
                    Text("Selected Player:")
                        .font(.caption)
                        .foregroundColor(.fnGray1)
                        .padding(.horizontal)
                    
                    ForEach(activeStudents.filter { selectedPlayerIDs.contains($0.id) }) { student in
                        SelectedPlayerRow(student: student)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
            } else {
                EmptyView()
            }
        }
    }
    
    private var emptyStateNoPlayers: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.fnGray1)
            
            Text("No Players Available")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.fnWhite)
            
            Text("Add players in the Players tab first")
                .font(.body)
                .foregroundColor(.fnGray1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                dismiss()
                // You could add navigation to Players tab here if needed
            } label: {
                Text("Go to Players")
                    .font(.headline)
                    .foregroundColor(.fnWhite)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.fnBlue)
                    .cornerRadius(12)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
    }
    
    private var emptyStateNoSearchResults: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "person.slash")
                .font(.system(size: 60))
                .foregroundColor(.fnGray1)
            
            Text("No Results Found")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.fnWhite)
            
            Text("Try a different search term")
                .font(.body)
                .foregroundColor(.fnGray1)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helper Properties
    
    private var canSave: Bool {
        selectedPlayerIDs.count == maxSelections
    }
    
    // MARK: - Methods
    
    private func toggleSelection(for student: Student) {
        if selectedPlayerIDs.contains(student.id) {
            selectedPlayerIDs.remove(student.id)
        } else if selectedPlayerIDs.count < maxSelections {
            selectedPlayerIDs.insert(student.id)
        }
    }
    
    private func saveSelectionAndDismiss() {
        // Get selected student(s)
        let selectedStudents = activeStudents.filter { selectedPlayerIDs.contains($0.id) }
        
        print("Selected for \(teamName): \(selectedStudents.map { $0.name })")
        
        // TODO: Save to your Game/Team model
        // You would typically:
        // 1. Create a GameTeam or similar model
        // 2. Add the selected players to it
        // 3. Save to SwiftData
        
        dismiss()
    }
}

// MARK: - Subviews

struct PlayerSelectionCell: View {
    let student: Student
    let isSelected: Bool
    let maxReached: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Selection Indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.fnBlue : Color.fnGray1, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.fnBlue)
                            .frame(width: 14, height: 14)
                    }
                }
                
                // Student Avatar (reusing your design)
                Circle()
                    .fill(student.skillLevel.color)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(String(student.name.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.fnWhite)
                    )
                
                // Student Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(student.name)
                            .font(.headline)
                            .foregroundColor(isSelected ? .fnWhite : .fnWhite)
                    }
                    
                    HStack(spacing: 8) {
                        Text("Grade \(student.grade)")
                            .font(.caption)
                            .foregroundColor(.fnGray1)
                        
                        Text("•")
                            .foregroundColor(.fnGray1)
                        
                        HStack(spacing: 4) {
                            Image(systemName: student.skillLevel.icon)
                                .font(.caption2)
                            Text(student.skillLevel.rawValue)
                                .font(.caption)
                        }
                        .foregroundColor(student.skillLevel.color)
                        
                        if !student.studentID.isEmpty {
                            Text("•")
                                .foregroundColor(.fnGray1)
                            
                            Text(student.studentID)
                                .font(.caption)
                                .foregroundColor(.fnGray1)
                        }
                    }
                }
                
                Spacer()
                
                // Lock icon if max reached and not selected
                if maxReached && !isSelected {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.fnGray1)
                        .font(.caption)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.fnBlue.opacity(0.2) : Color.fnGray2.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.fnBlue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .disabled(maxReached && !isSelected)
        .opacity(maxReached && !isSelected ? 0.6 : 1.0)
    }
}

struct SelectedPlayerRow: View {
    let student: Student
    
    var body: some View {
        HStack(spacing: 16) {
            // Student Avatar
            Circle()
                .fill(student.skillLevel.color)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(student.name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.fnWhite)
                )
            
            // Student Info
            VStack(alignment: .leading, spacing: 4) {
                Text(student.name)
                    .font(.headline)
                    .foregroundColor(.fnWhite)
                
                HStack(spacing: 8) {
                    Text("Grade \(student.grade)")
                        .font(.caption)
                        .foregroundColor(.fnGray1)
                    
                    Text("•")
                        .foregroundColor(.fnGray1)
                    
                    HStack(spacing: 4) {
                        Image(systemName: student.skillLevel.icon)
                            .font(.caption2)
                        Text(student.skillLevel.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(student.skillLevel.color)
                }
            }
            
            Spacer()
            
            // Checkmark to indicate selected
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.fnGreen)
                .font(.title3)
        }
        .padding()
        .background(Color.fnBlue.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Student.self, configurations: config)
    
    // Create sample students (using your existing Student model)
    // Updated to match your actual Student initializer
    let sampleStudents = [
        Student(name: "Alex Martinez", grade: 11, skillLevel: .pro, studentID: "AM001"),
        Student(name: "Jordan Lee", grade: 10, skillLevel: .advanced, studentID: "JL002"),
        Student(name: "Taylor Smith", grade: 12, skillLevel: .advanced, studentID: "TS003"),
        Student(name: "Casey Johnson", grade: 11, skillLevel: .intermediate, studentID: "CJ004"),
        Student(name: "Morgan Davis", grade: 9, skillLevel: .intermediate, studentID: "MD005"),
    ]
    
    // Insert sample data
    for student in sampleStudents {
        container.mainContext.insert(student)
    }
    
    return TeamSelectorView(teamName: "Team 1 Players")
        .modelContainer(container)
}
