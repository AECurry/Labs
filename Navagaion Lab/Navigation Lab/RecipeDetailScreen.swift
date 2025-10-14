//
//  RecipeDetailScreen.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI

struct RecipeDetailScreen: View {
    @EnvironmentObject var recipeManager: RecipeManager // Add this
    @Environment(\.dismiss) var dismiss
    let recipe: Recipes
    
    @State private var showingEditScreen = false
    @State private var navigationPath = NavigationPath()
    
    private var isInMyRecipes: Bool {
        recipeManager.myRecipes.contains(where: { $0.id == recipe.id })
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Recipe Image
                    if let image = recipe.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("No Image")
                                        .foregroundColor(.gray)
                                }
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(recipe.name)
                            .font(.largeTitle)
                            .bold()
                        
                        // Favorite Button - THIS IS WHAT MAKES THE HEART WORK
                        Button {
                            recipeManager.toggleFavorite(recipe) // This calls the toggle function
                            // Navigate back to the appropriate tab
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: isInMyRecipes ? "heart.slash" : "heart.fill")
                                Text(isInMyRecipes ? "Remove from My Recipes" : "Add to My Recipes")
                            }
                            .foregroundColor(isInMyRecipes ? .red : .blue)
                        }
                        .buttonStyle(.bordered)
                        
                        // ... rest of your existing code for ingredients and instructions ...
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ingredients")
                                .font(.title2)
                                .bold()
                            
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Text("• \(ingredient)")
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Instructions")
                                .font(.title2)
                                .bold()
                            
                            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                                Text("\(index + 1). \(instruction)")
                                    .padding(.bottom, 4)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Recipe Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "pencil")
                    }
                }
            }
            .sheet(isPresented: $showingEditScreen) {
                EditRecipeScreen(recipe: recipe)
            }
        }
    }
}
