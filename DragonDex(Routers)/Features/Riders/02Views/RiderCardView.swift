//
//  RiderCardView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/5/25.
//

import SwiftUI

struct RiderCardView: View {
    let rider: Rider
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(rider.name)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(rider.rank)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "clock.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(rider.totalFlightHours) hours")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        RiderCardView(
            rider: Rider(
                name: "Aria Stormwind",
                age: 24,
                rank: "Dragon Master",
                bio: "Champion rider with unmatched aerial skills.",
                avatar: "person.circle.fill",
                dragonsBonded: ["Zephyros", "Tempest"],
                achievements: ["First Flight", "Sky Champion"],
                totalFlightHours: 1250
            )
        )
        
        RiderCardView(
            rider: Rider(
                name: "Kael Fireheart",
                age: 42,
                rank: "Elder Rider",
                bio: "Experienced rider with decades of flying.",
                avatar: "person.circle.fill",
                dragonsBonded: ["Ignarius", "Ember"],
                achievements: ["Master Rider", "Fire Master"],
                totalFlightHours: 2100
            )
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
