//
//  AddRecipeSheet.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI
import PhotosUI

struct AddRecipeSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var recipeManager: RecipeManager
    
    @State private var recipeName = ""
    @State private var ingredients: [String] = [""]
    @State private var instructions: [String] = [""]
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var recipeImage: Image?
    @State private var selectedUIImage: UIImage?
    
    var body: some View {
        NavigationStack {
            Form {
                // Image Section
                Section(header: Text("Recipe Image")) {
                    VStack(alignment: .center) {
                        if let recipeImage = recipeImage {
                            recipeImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        Text("Tap to Add Photo")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                                .cornerRadius(12)
                        }
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Text(recipeImage == nil ? "Add Photo" : "Change Photo")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 8)
                }
                
                // Recipe Name Section
                Section(header: Text("Recipe Name")) {
                    TextField("Enter recipe name", text: $recipeName)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                }
                
                // Ingredients Section
                Section(header: Text("Ingredients")) {
                    ForEach(0..<ingredients.count, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $ingredients[index])
                            .autocorrectionDisabled(true)
                    }
                    
                    Button("Add Ingredient") {
                        ingredients.append("")
                    }
                    
                    if ingredients.count > 1 {
                        Button("Remove Last Ingredient", role: .destructive) {
                            ingredients.removeLast()
                        }
                    }
                }
                
                // Instructions Section
                Section(header: Text("Instructions")) {
                    ForEach(0..<instructions.count, id: \.self) { index in
                        TextField("Step \(index + 1)", text: $instructions[index])
                            .autocorrectionDisabled(true)
                    }
                    
                    Button("Add Step") {
                        instructions.append("")
                    }
                    
                    if instructions.count > 1 {
                        Button("Remove Last Step", role: .destructive) {
                            instructions.removeLast()
                        }
                    }
                }
            }
            .navigationTitle("Add New Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let imageData = selectedUIImage?.jpegData(compressionQuality: 0.8)
                        let newRecipe = Recipes(
                            name: recipeName.trimmingCharacters(in: .whitespacesAndNewlines),
                            ingredients: ingredients.filter { !$0.isEmpty },
                            instructions: instructions.filter { !$0.isEmpty },
                            imageData: imageData
                        )
                        recipeManager.myRecipes.append(newRecipe)
                        dismiss()
                    }
                    .disabled(recipeName.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) {
                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                        selectedUIImage = UIImage(data: data) // Store the UIImage directly
                        if let uiImage = selectedUIImage {
                            recipeImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
        }
    }
}
