//
//  EditRecipeScreen.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI
import PhotosUI

struct EditRecipeScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var recipeManager: RecipeManager
    @State var recipe: Recipes
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var recipeImage: Image?
    
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
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
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
                
                // Basic Info Section
                Section(header: Text("Recipe Details")) {
                    TextField("Recipe Name", text: $recipe.name)
                }
                
                // Ingredients Section
                Section(header: Text("Ingredients")) {
                    ForEach(0..<recipe.ingredients.count, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $recipe.ingredients[index])
                    }
                    
                    Button("Add Ingredient") {
                        recipe.ingredients.append("")
                    }
                    
                    if recipe.ingredients.count > 1 {
                        Button("Remove Last Ingredient", role: .destructive) {
                            recipe.ingredients.removeLast()
                        }
                    }
                }
                
                // Instructions Section
                Section(header: Text("Instructions")) {
                    ForEach(0..<recipe.instructions.count, id: \.self) { index in
                        TextField("Step \(index + 1)", text: $recipe.instructions[index])
                    }
                    
                    Button("Add Step") {
                        recipe.instructions.append("")
                    }
                    
                    if recipe.instructions.count > 1 {
                        Button("Remove Last Step", role: .destructive) {
                            recipe.instructions.removeLast()
                        }
                    }
                }
            }
            .navigationTitle("Edit Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        recipeManager.updateRecipe(recipe)
                        dismiss()
                    }
                    .disabled(recipe.name.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) {
                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                        recipe.imageData = data
                        if let uiImage = UIImage(data: data) {
                            recipeImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
            .onAppear {
                // Load existing image if available
                if let image = recipe.image {
                    recipeImage = image
                }
            }
        }
    }
}
