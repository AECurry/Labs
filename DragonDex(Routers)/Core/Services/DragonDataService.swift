//
//  DragonDataService.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

@Observable
final class DragonDataService {
    private var modelContext: ModelContext?
    private var mockDragons: [Dragon] = []
    
    var dragons: [Dragon] {
        if let context = modelContext {
            let descriptor = FetchDescriptor<Dragon>(
                sortBy: [SortDescriptor(\.name)]
            )
            do {
                return try context.fetch(descriptor)
            } catch {
                print("Error fetching from SwiftData: \(error)")
                return mockDragons
            }
        } else {
            return mockDragons
        }
    }
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        if modelContext == nil {
            loadMockDragons()
        } else {
            seedInitialDataIfNeeded()
        }
    }
    
    private func loadMockDragons() {
        mockDragons = [
            Dragon(
                name: "Ignarius",
                species: "Fire Dragon",
                lore: "Born in the heart of an active volcano, Ignarius commands flames that can melt steel.",
                fireRating: 10,
                thumbnail: "FireDragon",
                artwork: "FireDragon",
                powers: ["Inferno Burst", "Lava Armor", "Flame Breath"]
            ),
            Dragon(
                name: "Zephyros",
                species: "Sky Dragon",
                lore: "Master of storms and wind, Zephyros soars through clouds with unmatched grace.",
                fireRating: 7,
                thumbnail: "SkyDragon",
                artwork: "SkyDragon",
                powers: ["Sky Dive", "Thunder Call", "Wind Shield"]
            ),
            Dragon(
                name: "Aqualis",
                species: "Water Dragon",
                lore: "Ancient guardian of the deep seas, capable of summoning tidal waves.",
                fireRating: 5,
                thumbnail: "WaterDragon",
                artwork: "WaterDragon",
                powers: ["Tidal Wave", "Water Heal", "Bubble Shield"]
            ),
            Dragon(
                name: "Terradon",
                species: "Earth Dragon",
                lore: "Mountain-sized beast with hide like granite and strength to shake the earth.",
                fireRating: 6,
                thumbnail: "EarthDragon",
                artwork: "EarthDragon",
                powers: ["Earthquake", "Stone Skin", "Crystal Spear"]
            ),
            Dragon(
                name: "Verdantis",
                species: "Plant Dragon",
                lore: "Nature's protector, able to grow forests in seconds and heal any wound.",
                fireRating: 4,
                thumbnail: "PlantDragon",
                artwork: "PlantDragon",
                powers: ["Forest Growth", "Nature's Heal", "Vine Whip"]
            ),
            Dragon(
                name: "Nebula",
                species: "Space Dragon",
                lore: "Cosmic entity that travels between stars, wielding the power of the universe.",
                fireRating: 9,
                thumbnail: "SpaceDragon",
                artwork: "SpaceDragon",
                powers: ["Meteor Strike", "Gravity Well", "Starlight Beam"]
            ),
            Dragon(
                name: "Venomfang",
                species: "Toxic Dragon",
                lore: "Deadly and cunning, its poison can corrupt entire kingdoms.",
                fireRating: 8,
                thumbnail: "ToxicDragon",
                artwork: "ToxicDragon",
                powers: ["Toxic Breath", "Plague Cloud", "Venom Bite"]
            )
        ]
    }
    
    private func seedInitialDataIfNeeded() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<Dragon>()
        if (try? context.fetchCount(descriptor)) ?? 0 > 0 {
            return
        }
        
        let dragons = [
            Dragon(
                name: "Ignarius",
                species: "Fire Dragon",
                lore: "Born in the heart of an active volcano, Ignarius commands flames that can melt steel.",
                fireRating: 10,
                thumbnail: "FireDragon",
                artwork: "FireDragon",
                powers: ["Inferno Burst", "Lava Armor", "Flame Breath"]
            ),
            Dragon(
                name: "Zephyros",
                species: "Sky Dragon",
                lore: "Master of storms and wind, Zephyros soars through clouds with unmatched grace.",
                fireRating: 7,
                thumbnail: "SkyDragon",
                artwork: "SkyDragon",
                powers: ["Sky Dive", "Thunder Call", "Wind Shield"]
            ),
            Dragon(
                name: "Aqualis",
                species: "Water Dragon",
                lore: "Ancient guardian of the deep seas, capable of summoning tidal waves.",
                fireRating: 5,
                thumbnail: "WaterDragon",
                artwork: "WaterDragon",
                powers: ["Tidal Wave", "Water Heal", "Bubble Shield"]
            ),
            Dragon(
                name: "Terradon",
                species: "Earth Dragon",
                lore: "Mountain-sized beast with hide like granite and strength to shake the earth.",
                fireRating: 6,
                thumbnail: "EarthDragon",
                artwork: "EarthDragon",
                powers: ["Earthquake", "Stone Skin", "Crystal Spear"]
            ),
            Dragon(
                name: "Verdantis",
                species: "Plant Dragon",
                lore: "Nature's protector, able to grow forests in seconds and heal any wound.",
                fireRating: 4,
                thumbnail: "PlantDragon",
                artwork: "PlantDragon",
                powers: ["Forest Growth", "Nature's Heal", "Vine Whip"]
            ),
            Dragon(
                name: "Nebula",
                species: "Space Dragon",
                lore: "Cosmic entity that travels between stars, wielding the power of the universe.",
                fireRating: 9,
                thumbnail: "SpaceDragon",
                artwork: "SpaceDragon",
                powers: ["Meteor Strike", "Gravity Well", "Starlight Beam"]
            ),
            Dragon(
                name: "Venomfang",
                species: "Toxic Dragon",
                lore: "Deadly and cunning, its poison can corrupt entire kingdoms.",
                fireRating: 8,
                thumbnail: "ToxicDragon",
                artwork: "ToxicDragon",
                powers: ["Toxic Breath", "Plague Cloud", "Venom Bite"]
            )
        ]
        
        dragons.forEach { context.insert($0) }
        
        do {
            try context.save()
            print("✅ SwiftData seeded with initial dragons")
        } catch {
            print("❌ Failed to seed SwiftData: \(error)")
        }
    }
    
    func toggleFavorite(_ dragon: Dragon) {
        dragon.isFavorite.toggle()
        saveIfNeeded()
    }
    
    private func saveIfNeeded() {
        guard let context = modelContext else { return }
        
        do {
            try context.save()
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
}
