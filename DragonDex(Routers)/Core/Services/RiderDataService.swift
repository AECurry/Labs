//
//  RiderDataService.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

@Observable
final class RiderDataService {
    private var modelContext: ModelContext?
    private var mockRiders: [Rider] = []
    
    var riders: [Rider] {
        if let context = modelContext {
            let descriptor = FetchDescriptor<Rider>(
                sortBy: [SortDescriptor(\.name)]
            )
            do {
                return try context.fetch(descriptor)
            } catch {
                print("Error fetching riders: \(error)")
                return mockRiders
            }
        } else {
            return mockRiders
        }
    }
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        if modelContext == nil {
            loadMockRiders()
        } else {
            seedInitialDataIfNeeded()
        }
    }
    
    private func loadMockRiders() {
        mockRiders = [
            Rider(
                name: "Aria Stormwind",
                age: 24,
                rank: "Dragon Master",
                bio: "Champion rider with unmatched aerial skills.",
                avatar: "person.circle.fill",
                dragonsBonded: ["Zephyros", "Tempest"],
                achievements: ["First Flight", "Sky Champion", "Master Rider"],
                totalFlightHours: 1250
            ),
            Rider(
                name: "Kael Fireheart",
                age: 28,
                rank: "Elder Rider",
                bio: "Legendary fire dragon tamer.",
                avatar: "flame.circle.fill",
                dragonsBonded: ["Ignarius", "Emberwing"],
                achievements: ["Fire Master", "Ancient Bond", "Dragon Whisperer"],
                totalFlightHours: 2100
            ),
            Rider(
                name: "Luna Moonshadow",
                age: 22,
                rank: "Junior Rider",
                bio: "Rising star with natural dragon affinity.",
                avatar: "moon.circle.fill",
                dragonsBonded: ["Stardust"],
                achievements: ["First Flight", "Night Rider"],
                totalFlightHours: 480
            )
        ]
    }
    
    private func seedInitialDataIfNeeded() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<Rider>()
        if (try? context.fetchCount(descriptor)) ?? 0 > 0 {
            return
        }
        
        let riders = [
            Rider(
                name: "Aria Stormwind",
                age: 24,
                rank: "Dragon Master",
                bio: "Champion rider with unmatched aerial skills.",
                avatar: "person.circle.fill",
                dragonsBonded: ["Zephyros", "Tempest"],
                achievements: ["First Flight", "Sky Champion", "Master Rider"],
                totalFlightHours: 1250
            ),
            Rider(
                name: "Kael Fireheart",
                age: 28,
                rank: "Elder Rider",
                bio: "Legendary fire dragon tamer.",
                avatar: "flame.circle.fill",
                dragonsBonded: ["Ignarius", "Emberwing"],
                achievements: ["Fire Master", "Ancient Bond", "Dragon Whisperer"],
                totalFlightHours: 2100
            ),
            Rider(
                name: "Luna Moonshadow",
                age: 22,
                rank: "Junior Rider",
                bio: "Rising star with natural dragon affinity.",
                avatar: "moon.circle.fill",
                dragonsBonded: ["Stardust"],
                achievements: ["First Flight", "Night Rider"],
                totalFlightHours: 480
            )
        ]
        
        riders.forEach { context.insert($0) }
        
        do {
            try context.save()
            print("✅ SwiftData seeded with initial riders")
        } catch {
            print("❌ Failed to seed riders: \(error)")
        }
    }
}
