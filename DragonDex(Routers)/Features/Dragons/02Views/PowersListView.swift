//
//  PowersListView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct PowersListView: View {
    let dragon: Dragon
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        List {
            ForEach(dragon.powers, id: \.self) { power in
                PowerRowView(powerName: power)
            }
        }
        .navigationTitle("\(dragon.name)'s Powers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PowerRowView: View {
    let powerName: String
    
    var body: some View {
        HStack {
            Image(systemName: powerIcon(for: powerName))
                .foregroundStyle(powerColor(for: powerName))
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(powerName)
                    .font(.headline)
                
                Text(powerDescription(for: powerName))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    // Helper functions for power icons and colors
    private func powerIcon(for power: String) -> String {
        if power.contains("Fire") || power.contains("Inferno") || power.contains("Flame") {
            return "flame.fill"
        } else if power.contains("Water") || power.contains("Tidal") || power.contains("Bubble") {
            return "drop.fill"
        } else if power.contains("Wind") || power.contains("Sky") || power.contains("Thunder") {
            return "wind"
        } else if power.contains("Earth") || power.contains("Stone") || power.contains("Crystal") {
            return "mountain.2.fill"
        } else if power.contains("Toxic") || power.contains("Venom") || power.contains("Plague") {
            return "cross.case.fill"
        } else if power.contains("Plant") || power.contains("Forest") || power.contains("Nature") || power.contains("Vine") {
            return "leaf.fill"
        } else if power.contains("Space") || power.contains("Meteor") || power.contains("Star") || power.contains("Gravity") {
            return "sparkles"
        } else {
            return "bolt.fill"
        }
    }
    
    private func powerColor(for power: String) -> Color {
        if power.contains("Fire") || power.contains("Inferno") || power.contains("Flame") {
            return .orange
        } else if power.contains("Water") || power.contains("Tidal") || power.contains("Bubble") {
            return .blue
        } else if power.contains("Wind") || power.contains("Sky") || power.contains("Thunder") {
            return .cyan
        } else if power.contains("Earth") || power.contains("Stone") || power.contains("Crystal") {
            return .brown
        } else if power.contains("Toxic") || power.contains("Venom") || power.contains("Plague") {
            return .green
        } else if power.contains("Plant") || power.contains("Forest") || power.contains("Nature") || power.contains("Vine") {
            return .green
        } else if power.contains("Space") || power.contains("Meteor") || power.contains("Star") || power.contains("Gravity") {
            return .purple
        } else {
            return .yellow
        }
    }
    
    private func powerDescription(for power: String) -> String {
        switch power {
        case "Inferno Burst": return "Devastating explosion of fire"
        case "Lava Armor": return "Protective shield of molten rock"
        case "Flame Breath": return "Stream of intense flames"
        case "Sky Dive": return "Lightning-fast aerial assault"
        case "Thunder Call": return "Summons powerful lightning strikes"
        case "Wind Shield": return "Deflects attacks with air currents"
        case "Tidal Wave": return "Massive wall of water"
        case "Water Heal": return "Restores health using water magic"
        case "Bubble Shield": return "Protective water barrier"
        case "Earthquake": return "Shakes the ground violently"
        case "Stone Skin": return "Hardens hide to granite-like toughness"
        case "Crystal Spear": return "Launches razor-sharp crystals"
        case "Forest Growth": return "Creates instant vegetation"
        case "Nature's Heal": return "Healing through plant magic"
        case "Vine Whip": return "Attacks with living vines"
        case "Meteor Strike": return "Calls down celestial destruction"
        case "Gravity Well": return "Manipulates gravitational forces"
        case "Starlight Beam": return "Concentrated cosmic energy blast"
        case "Toxic Breath": return "Poisonous gas attack"
        case "Plague Cloud": return "Spreading corruption and disease"
        case "Venom Bite": return "Deadly poisonous strike"
        default: return "A powerful dragon ability"
        }
    }
}

#Preview {
    NavigationStack {
        PowersListView(
            dragon: Dragon(
                name: "Ignarius",
                species: "Fire Dragon",
                lore: "Ancient fire elemental",
                fireRating: 9,
                thumbnail: "FireDragon",
                artwork: "FireDragon",
                powers: ["Inferno Burst", "Lava Armor", "Flame Breath"]
            )
        )
        .environment(ThemeBackground())
    }
}
