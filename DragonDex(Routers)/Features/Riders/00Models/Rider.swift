//
//  Rider.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

@Model
class Rider {
    @Attribute(.unique) var id: UUID
    var name: String
    var age: Int
    var rank: String
    var bio: String
    var avatar: String
    var dragonsBonded: [String]
    var achievements: [String]
    var totalFlightHours: Int
    var dateJoined: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        age: Int,
        rank: String,
        bio: String,
        avatar: String,
        dragonsBonded: [String] = [],
        achievements: [String] = [],
        totalFlightHours: Int = 0,
        dateJoined: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.rank = rank
        self.bio = bio
        self.avatar = avatar
        self.dragonsBonded = dragonsBonded
        self.achievements = achievements
        self.totalFlightHours = totalFlightHours
        self.dateJoined = dateJoined
    }
}

