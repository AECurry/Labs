//
//  PersonalInfoSection.swift
//  GamesTrackerProject#9
//

import SwiftUI

struct PersonalInfoSection: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var studentID: String
    @Binding var grade: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Personal Information")
            
            VStack(spacing: 16) {
                // Name fields - using custom placeholder to match .fnGray1
                HStack(spacing: 12) {
                    TextField("", text: $firstName)
                        .placeholder(when: firstName.isEmpty) {
                            Text("First Name")
                                .foregroundColor(.fnGray1) // Changed to match Student ID
                        }
                        .padding()
                        .background(Color.fnGray2)
                        .foregroundColor(.fnBlack) // Typed text is black
                        .cornerRadius(8)
                        .autocapitalization(.words)
                    
                    TextField("", text: $lastName)
                        .placeholder(when: lastName.isEmpty) {
                            Text("Last Name")
                                .foregroundColor(.fnGray1) // Changed to match Student ID
                        }
                        .padding()
                        .background(Color.fnGray2)
                        .foregroundColor(.fnBlack) // Typed text is black
                        .cornerRadius(8)
                        .autocapitalization(.words)
                }
                
                // Student ID field - already using .fnGray1
                TextField("", text: $studentID)
                    .placeholder(when: studentID.isEmpty) {
                        Text("Student ID")
                            .foregroundColor(.fnGray1) // This is correct
                    }
                    .padding()
                    .background(Color.fnGray2)
                    .foregroundColor(.fnBlack) // Typed text is black
                    .cornerRadius(8)
                    .keyboardType(.numberPad)
                
                // Add spacing
                Spacer()
                    .frame(height: 4)
                
                // Grade picker
                GradePicker(selectedGrade: $grade)
            }
        }
        .sectionStyle()
    }
}

// MARK: - Placeholder View Modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Grade Picker Component (keep as before)
struct GradePicker: View {
    @Binding var selectedGrade: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Grade Level")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            HStack(spacing: 12) {
                ForEach([9, 10, 11, 12], id: \.self) { grade in
                    Button {
                        selectedGrade = grade
                    } label: {
                        Text("\(grade)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(selectedGrade == grade ? .fnWhite : .fnGray1)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                selectedGrade == grade ?
                                Color.fnBlue : Color.fnGray2
                            )
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        PersonalInfoSection(
            firstName: .constant(""),
            lastName: .constant(""),
            studentID: .constant(""),
            grade: .constant(9)
        )
        .padding()
    }
}
