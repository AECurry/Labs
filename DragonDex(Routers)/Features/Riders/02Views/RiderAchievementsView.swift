//
//  RiderAchievementsView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct RiderAchievementsView: View {
    let rider: Rider
    @Environment(ThemeBackground.self) private var themeService
    
    var body: some View {
        List {
            ForEach(rider.achievements, id: \.self) { achievement in
                AchievementRowView(achievement: achievement)
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AchievementRowView: View {
    let achievement: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievementIcon(for: achievement))
                .font(.title2)
                .foregroundStyle(achievementColor(for: achievement))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement)
                    .font(.headline)
                
                Text(achievementDescription(for: achievement))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private func achievementIcon(for achievement: String) -> String {
        switch achievement {
        case "First Flight": return "airplane.departure"
        case "Sky Champion": return "cloud.sun.fill"
        case "Master Rider": return "crown.fill"
        case "Fire Master": return "flame.fill"
        case "Ancient Bond": return "link"
        case "Dragon Whisperer": return "waveform"
        case "Night Rider": return "moon.stars.fill"
        default: return "trophy.fill"
        }
    }
    
    private func achievementColor(for achievement: String) -> Color {
        switch achievement {
        case "First Flight": return .blue
        case "Sky Champion": return .cyan
        case "Master Rider": return .purple
        case "Fire Master": return .orange
        case "Ancient Bond": return .brown
        case "Dragon Whisperer": return .green
        case "Night Rider": return .indigo
        default: return .yellow
        }
    }
    
    private func achievementDescription(for achievement: String) -> String {
        switch achievement {
        case "First Flight": return "Completed first dragon flight"
        case "Sky Champion": return "Won aerial tournament"
        case "Master Rider": return "Achieved highest rider rank"
        case "Fire Master": return "Bonded with fire dragon"
        case "Ancient Bond": return "Connected with ancient dragon"
        case "Dragon Whisperer": return "Communicate telepathically"
        case "Night Rider": return "Mastered nocturnal flying"
        default: return "Special achievement unlocked"
        }
    }
}

#Preview {
    NavigationStack {
        RiderAchievementsView(
            rider: Rider(
                name: "Aria Stormwind",
                age: 24,
                rank: "Dragon Master",
                bio: "Champion rider",
                avatar: "person.circle.fill",
                achievements: ["First Flight", "Sky Champion", "Master Rider"]
            )
        )
        .environment(ThemeBackground())
    }
}
