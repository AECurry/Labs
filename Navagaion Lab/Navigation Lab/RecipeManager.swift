//
//  RecipeManager.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI
import Combine

class RecipeManager: ObservableObject {
    @Published var myRecipes: [Recipes] = []
    @Published var discoverRecipes: [Recipes] = [
        Recipes(name: "Spaghetti Carbonara",
               ingredients: ["Spaghetti", "Eggs", "Pancetta", "Parmesan", "Black Pepper"],
               instructions: ["Cook pasta", "Mix eggs and cheese", "Combine everything"]),
        Recipes(name: "Chicken Curry",
               ingredients: ["Chicken", "Curry Powder", "Coconut Milk", "Onions", "Garlic"],
               instructions: ["Sauté onions", "Add chicken", "Add curry sauce"])
    ]
    
    func toggleFavorite(_ recipe: Recipes) {
        if let index = discoverRecipes.firstIndex(where: { $0.id == recipe.id }) {
            // Move from Discover to My Recipes
            let recipe = discoverRecipes.remove(at: index)
            myRecipes.append(recipe)
        } else if let index = myRecipes.firstIndex(where: { $0.id == recipe.id }) {
            // Move from My Recipes to Discover
            let recipe = myRecipes.remove(at: index)
            discoverRecipes.append(recipe)
        }
    }
    
    func updateRecipe(_ updatedRecipe: Recipes) {
        if let index = myRecipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            myRecipes[index] = updatedRecipe
        }
        if let index = discoverRecipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            discoverRecipes[index] = updatedRecipe
        }
    }
}
