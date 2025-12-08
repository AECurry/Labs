//
//  DragonCardView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct DragonCardView: View {
    let dragon: Dragon
    @Environment(DragonDataService.self) private var dragonService
    
    var body: some View {
        HStack(spacing: 16) {
            // Dragon Image
            Image(dragon.thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Dragon Info
            VStack(alignment: .leading, spacing: 6) {
                Text(dragon.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(dragon.species)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("Fire Rating: \(dragon.fireRating)")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // Favorite Button
            Button {
                dragonService.toggleFavorite(dragon)
            } label: {
                Image(systemName: dragon.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(dragon.isFavorite ? .yellow : .gray)
                    .font(.title2)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    DragonCardView(
        dragon: Dragon(
            name: "Ignarius",
            species: "Fire Dragon",
            lore: "Ancient fire elemental",
            fireRating: 9,
            thumbnail: "FireDragon",
            artwork: "FireDragon",
            powers: ["Inferno Burst"]
        )
    )
    .environment(DragonDataService())
    .padding()
}
