//
//  MusicOption.swift
//  MASUKI
//
//  Created by [Your Name] on [Date].
//

import Foundation

struct MusicOption: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let isPremium: Bool
    
    // Sample options
    static let placeholder = MusicOption(
        id: "placeholder",
        name: "No Music",
        description: "Silent walk",
        isPremium: false
    )
    
    static let zenGarden = MusicOption(
        id: "zen_garden",
        name: "Zen Garden",
        description: "Peaceful garden sounds",
        isPremium: false
    )
    
    static let forestWalk = MusicOption(
        id: "forest_walk",
        name: "Forest Walk",
        description: "Nature sounds",
        isPremium: false
    )
    
    static let oceanWaves = MusicOption(
        id: "ocean_waves",
        name: "Ocean Waves",
        description: "Calming ocean sounds",
        isPremium: true
    )
    
    static let allOptions: [MusicOption] = [
        .placeholder,
        .zenGarden,
        .forestWalk,
        .oceanWaves
    ]
}

