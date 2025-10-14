//
//  EditFamilyMemberView.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI
// Remove: import PhotosUI

struct EditFamilyMemberView: View {
    @Binding var member: FamilyMember
    @Environment(\.dismiss) private var dismiss
    // Remove: @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            Form {
                // Photo Section - SIMPLIFIED
                Section(header: Text("Profile Photo")) {
                    HStack {
                        Spacer()
                        
                        if let assetName = member.assetPhotoName {
                            // Use the asset photo
                            Image(assetName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            // Fallback for new members
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .padding(30)
                                .background(Circle().fill(Color.gray.opacity(0.2)))
                        }
                        
                        Spacer()
                    }
                    
                    Text("Profile photos from assets")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                // Basic Info Section
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $member.name)
                    TextField("Relationship", text: $member.relationship)
                    Stepper("Age: \(member.age)", value: $member.age, in: 0...120)
                }
                
                // About Section
                Section(header: Text("About")) {
                    TextEditor(text: $member.bio)
                        .frame(minHeight: 100)
                }
                
                // Hobbies Section
                Section(header: Text("Hobbies (comma separated)")) {
                    TextField("Gardening, Cooking, Reading", text: Binding(
                        get: { member.hobbies.joined(separator: ", ") },
                        set: {
                            member.hobbies = $0.split(separator: ",")
                                .map { $0.trimmingCharacters(in: .whitespaces) }
                                .filter { !$0.isEmpty }
                        }
                    ))
                }
            }
            .navigationTitle("Edit Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
