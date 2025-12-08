//
//  RiderDragonsView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct RiderDragonsView: View {
    let rider: Rider
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        List {
            ForEach(rider.dragonsBonded, id: \.self) { dragonName in
                BondedDragonRowView(dragonName: dragonName)
            }
        }
        .navigationTitle("Bonded Dragons")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BondedDragonRowView: View {
    let dragonName: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "flame.circle.fill")
                .font(.title)
                .foregroundStyle(dragonColor(for: dragonName))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(dragonName)
                    .font(.headline)
                
                Text("Bond Level: Strong")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.green)
        }
        .padding(.vertical, 8)
    }
    
    private func dragonColor(for name: String) -> Color {
        if name.contains("Fire") || name.contains("Ember") || name.contains("Ignarius") {
            return .orange
        } else if name.contains("Sky") || name.contains("Storm") || name.contains("Zephyros") {
            return .cyan
        } else if name.contains("Water") || name.contains("Aqua") {
            return .blue
        } else if name.contains("Star") || name.contains("Space") {
            return .purple
        } else {
            return .red
        }
    }
}

#Preview {
    NavigationStack {
        RiderDragonsView(
            rider: Rider(
                name: "Aria Stormwind",
                age: 24,
                rank: "Dragon Master",
                bio: "Champion rider",
                avatar: "person.circle.fill",
                dragonsBonded: ["Zephyros", "Tempest", "Stardust"]
            )
        )
        .environment(ThemeBackground())
    }
}
