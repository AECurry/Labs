//
//  AddStudentView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData

struct AddStudentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var grade = 9
    @State private var skillLevel: SkillLevel = .intermediate
    @State private var studentID = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let grades = [9, 10, 11, 12]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                Form {
                    Section("Personal Information") {
                        TextField("First Name", text: $firstName)
                            .foregroundColor(.fnWhite)
                        TextField("Last Name", text: $lastName)
                            .foregroundColor(.fnWhite)
                        
                        Picker("Grade Level", selection: $grade) {
                            ForEach(grades, id: \.self) { grade in
                                Text("Grade \(grade)")
                                    .tag(grade)
                            }
                        }
                        .foregroundColor(.fnWhite)
                    }
                    .listRowBackground(Color.fnGray2)
                    
                    Section("Student Details") {
                        TextField("Student ID (Optional)", text: $studentID)
                            .foregroundColor(.fnWhite)
                            .keyboardType(.default)
                        
                        TextField("Email (Optional)", text: $email)
                            .foregroundColor(.fnWhite)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        TextField("Phone (Optional)", text: $phoneNumber)
                            .foregroundColor(.fnWhite)
                            .keyboardType(.phonePad)
                    }
                    .listRowBackground(Color.fnGray2)
                    
                    Section("Gaming Profile") {
                        Picker("Skill Level", selection: $skillLevel) {
                            ForEach(SkillLevel.allCases, id: \.self) { level in
                                HStack {
                                    Image(systemName: level.icon)
                                        .foregroundColor(level.color)
                                    Text(level.rawValue)
                                        .foregroundColor(.fnWhite)
                                }
                                .tag(level)
                            }
                        }
                        .foregroundColor(.fnWhite)
                    }
                    .listRowBackground(Color.fnGray2)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.fnWhite)
            }
            .navigationTitle("Add Student")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.fnWhite)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveStudent()
                    }
                    .foregroundColor(canSave ? .fnBlue : .fnGray1)
                    .disabled(!canSave)
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
    
    private func saveStudent() {
        guard canSave else {
            errorMessage = "Please enter first and last name"
            showingError = true
            return
        }
        
        let fullName = "\(firstName.trimmingCharacters(in: .whitespacesAndNewlines)) \(lastName.trimmingCharacters(in: .whitespacesAndNewlines))"
        
        let student = Student(
            name: fullName,
            grade: grade,
            skillLevel: skillLevel,
            studentID: studentID.trimmingCharacters(in: .whitespacesAndNewlines),
            email: email.isEmpty ? nil : email.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        modelContext.insert(student)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save student: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    AddStudentView()
        .modelContainer(for: Student.self, inMemory: true)
}
