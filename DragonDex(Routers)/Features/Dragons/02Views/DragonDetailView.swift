//
//  DragonDetailView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct DragonDetailView: View {
    let dragon: Dragon
    @Environment(DragonRouter.self) private var router
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Dragon Artwork
                Image(dragon.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .background(themeBackground.themeColor.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Dragon Info Card
                VStack(alignment: .leading, spacing: 16) {
                    Text(dragon.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(dragon.species)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    // Fire Rating
                    HStack {
                        Text("Fire Rating:")
                            .font(.headline)
                        ForEach(0..<dragon.fireRating, id: \.self) { _ in
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.orange)
                        }
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Lore
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Lore")
                            .font(.headline)
                        Text(dragon.lore)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    // Powers Button
                    Button {
                        router.navigateToPowers(dragon)
                    } label: {
                        HStack {
                            Image(systemName: "bolt.fill")
                            Text("View Powers (\(dragon.powers.count))")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(themeBackground.themeColor.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .padding()
        }
        .background(themeBackground.themeColor.opacity(0.05))
        .navigationTitle(dragon.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DragonDetailView(
            dragon: Dragon(
                name: "Ignarius",
                species: "Fire Dragon",
                lore: "Ancient fire elemental born in volcanic depths.",
                fireRating: 9,
                thumbnail: "FireDragon",
                artwork: "FireDragon",
                powers: ["Inferno Burst", "Lava Armor"]
            )
        )
        .environment(DragonRouter())
        .environment(ThemeBackground())
    }
}
