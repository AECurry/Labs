//
//  Team.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftData
import SwiftUI

@Model
class Team {
    @Attribute(.unique) var id: UUID
    var name: String
    var score: Int
    var colorAssetName: String 
    var isWinning: Bool = false
    
    // Relationships
    @Relationship(deleteRule: .nullify, inverse: \Game.team1) var gamesAsTeam1: [Game]?
    @Relationship(deleteRule: .nullify, inverse: \Game.team2) var gamesAsTeam2: [Game]?
    
    init(id: UUID = UUID(),
         name: String,
         score: Int = 0,
         colorAssetName: String = "FortniteBlue",  // Default to a Fortnite color
         isWinning: Bool = false) {
        self.id = id
        self.name = name
        self.score = score
        self.colorAssetName = colorAssetName
        self.isWinning = isWinning
    }
    
    // Computed property for SwiftUI Color
    var logoColor: Color {
        Color(colorAssetName)
    }
}
