//
//  DiscoverView.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(recipeManager.discoverRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailScreen(recipe: recipe)) {
                        Text(recipe.name)
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
}
