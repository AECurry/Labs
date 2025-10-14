//
//  MyRecipesScreen.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI

struct MyRecipesScreen: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var showingAddRecipe = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background that fills entire screen
                Color.warmSand
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Buttons HStack at the top
                    HStack {
                        // Edit/Done button on leading side (hidden until recipes exist)
                        if !recipeManager.myRecipes.isEmpty {
                            Button(isEditing ? "Done" : "Edit") {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            }
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.cream)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.darkBrown)
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                        
                        // Plus button with circle on trailing side
                        Button {
                            showingAddRecipe = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.darkBrown)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // My Recipes title with space below buttons
                    HStack {
                        Text("My Recipes")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.darkBrown)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                    .padding(.bottom, 8)
                    
                    // Content Area
                    if recipeManager.myRecipes.isEmpty {
                        Spacer()
                        VStack(spacing: 20) {
                            Image(systemName: "book.closed.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.darkBrown.opacity(0.5))
                            
                            Text("No Recipes Yet")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.darkBrown)
                            
                            Text("Tap the + button to add your first recipe!")
                                .font(.body)
                                .foregroundColor(.darkBrown.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(recipeManager.myRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailScreen(recipe: recipe)) {
                                    Text(recipe.name)
                                        .font(.body)
                                        .foregroundColor(.darkBrown)
                                        .padding(.vertical, 8)
                                }
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowBackground(Color.cream)
                            }
                            .onDelete(perform: deleteRecipe)
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.warmSand)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        }
        .sheet(isPresented: $showingAddRecipe) {
            AddRecipeSheet()
        }
    }
    
    private func deleteRecipe(at offsets: IndexSet) {
        withAnimation {
            recipeManager.myRecipes.remove(atOffsets: offsets)
        }
    }
}
