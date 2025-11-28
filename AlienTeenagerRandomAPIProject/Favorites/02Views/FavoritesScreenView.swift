//
//  FavoritesScreenView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct FavoritesScreenView: View {
    var body: some View {
        ZStack {
            CustomGradientBkg2()
            Text("Favorites Coming Soon!")
                .font(.title)
                .foregroundColor(.white)
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    NavigationStack {
        FavoritesScreenView()
    }
}

