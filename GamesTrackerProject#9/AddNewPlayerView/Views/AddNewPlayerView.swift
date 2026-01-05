//
//  AddNewPlayerView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

// Main Parent View for AddNewPlayerView folder should be kept dumb

import SwiftUI
import SwiftData

struct AddNewPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var grade = 9
    @State private var skillLevel: SkillLevel = .intermediate
    @State private var studentID = ""
    
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        PhotoPlaceholderSection()
                        
                        PersonalInfoSection(
                            firstName: $firstName,
                            lastName: $lastName,
                            studentID: $studentID,
                            grade: $grade
                        )
                        
                        GamingProfileSection(
                            skillLevel: $skillLevel
                        )
                        
                        SaveButton(
                            title: "Save Player",
                            isEnabled: canSave,
                            isSaving: isSaving,
                            action: savePlayer
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Add New Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.fnWhite)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var canSave: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func savePlayer() {
        guard canSave else {
            errorMessage = "Please enter first and last name"
            showingError = true
            return
        }
        
        isSaving = true
        
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let fullName = "\(trimmedFirstName) \(trimmedLastName)"
        
        let student = Student(
            name: fullName,
            grade: grade,
            skillLevel: skillLevel,
            studentID: studentID.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        modelContext.insert(student)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save player: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Student.self, configurations: config)
    
    return AddNewPlayerView()
        .modelContainer(container)
}
