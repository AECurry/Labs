//
//  Dragon.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

@Model
class Dragon {
    @Attribute(.unique) var id: UUID
    var name: String
    var species: String
    var lore: String
    var fireRating: Int
    var thumbnail: String
    var artwork: String
    var powers: [String]
    
    // SwiftData relationships
    @Relationship(deleteRule: .cascade) var detailedPowers: [Power]?
    
    // User progress
    var isUnlocked: Bool
    var isFavorite: Bool
    var dateDiscovered: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        species: String,
        lore: String,
        fireRating: Int,
        thumbnail: String,
        artwork: String,
        powers: [String] = [],
        isUnlocked: Bool = true,
        isFavorite: Bool = false,
        dateDiscovered: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.lore = lore
        self.fireRating = fireRating
        self.thumbnail = thumbnail
        self.artwork = artwork
        self.powers = powers
        self.isUnlocked = isUnlocked
        self.isFavorite = isFavorite
        self.dateDiscovered = dateDiscovered
    }
}
