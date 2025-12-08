//
//  Power.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

@Model
class Power {
    @Attribute(.unique) var id: UUID
    var name: String
    var powerDescription: String  // Changed from 'description'
    var manaCost: Int
    var element: String
    
    // Back reference to dragon
    @Relationship var dragon: Dragon?
    
    init(
        id: UUID = UUID(),
        name: String,
        powerDescription: String,  // Changed from 'description'
        manaCost: Int,
        element: String
    ) {
        self.id = id
        self.name = name
        self.powerDescription = powerDescription  // Changed from 'description'
        self.manaCost = manaCost
        self.element = element
    }
}
