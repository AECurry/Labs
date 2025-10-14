//
//  MainTabView.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var recipeManager = RecipeManager()
    
    var body: some View {
        TabView {
            MyRecipesScreen()
                .environmentObject(recipeManager)
                .tabItem {
                    Label("My Recipes", systemImage: "book.fill")
                }
                .toolbarBackground(Color.cream, for: .tabBar) // Add here
            
            DiscoverView()
                .environmentObject(recipeManager)
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .toolbarBackground(Color.cream, for: .tabBar) // Add here
        }
        .accentColor(.darkBrown)
        .toolbarBackground(Color.cream, for: .tabBar) // Keep this too
        .toolbarBackground(.visible, for: .tabBar)
    }
}
