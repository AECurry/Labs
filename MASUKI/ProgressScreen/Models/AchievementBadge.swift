//
//  AchievementBadge.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import Foundation
import SwiftUI

struct AchievementBadge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let isUnlocked: Bool
    let unlockDate: Date?
    let requirement: String
    
    // All badges use mediumJungle as requested
    var color: Color {
        MasukiColors.mediumJungle
    }
}

