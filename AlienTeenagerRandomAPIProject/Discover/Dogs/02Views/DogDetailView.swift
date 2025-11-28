//
//  DogDetailView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

/// Detail view for editing dog names - Required by assignment
struct DogDetailView: View {
    let dog: ListedDog
    let onSave: (ListedDog) -> Void
    @State private var editedName: String
    @Environment(\.dismiss) private var dismiss
    
    init(dog: ListedDog, onSave: @escaping (ListedDog) -> Void) {
        self.dog = dog
        self.onSave = onSave
        self._editedName = State(initialValue: dog.name)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(uiImage: dog.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                
                TextField("Dog Name", text: $editedName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Dog Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var updatedDog = dog
                        updatedDog.name = editedName
                        onSave(updatedDog)
                        dismiss()
                    }
                    .disabled(editedName.isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    DogDetailView(
        dog: ListedDog(
            image: UIImage(systemName: "photo")!,
            name: "Buddy"
        )
    ) { updatedDog in
        print("Saved: \(updatedDog.name)")
    }
}

