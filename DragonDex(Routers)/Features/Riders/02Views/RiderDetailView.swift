//
//  RiderDetailView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct RiderDetailView: View {
    let rider: Rider
    @Environment(RiderRouter.self) private var router
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Avatar
                Image(systemName: rider.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(themeBackground.themeColor)
                    .padding()
                    .background(themeBackground.themeColor.opacity(0.2))
                    .clipShape(Circle())
                
                // Rider Info
                VStack(spacing: 12) {
                    Text(rider.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(rider.rank)
                        .font(.title2)
                        .foregroundStyle(themeBackground.themeColor)
                    
                    HStack {
                        Text("Age: \(rider.age)")
                        Text("•")
                        Text("\(rider.totalFlightHours) flight hours")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                Divider()
                
                // Bio
                VStack(alignment: .leading, spacing: 8) {
                    Text("Biography")
                        .font(.headline)
                    Text(rider.bio)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        router.navigateToDragons(rider)
                    } label: {
                        HStack {
                            Image(systemName: "flame.fill")
                            Text("Bonded Dragons (\(rider.dragonsBonded.count))")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(themeBackground.themeColor.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        router.navigateToAchievements(rider)
                    } label: {
                        HStack {
                            Image(systemName: "trophy.fill")
                            Text("Achievements (\(rider.achievements.count))")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(themeBackground.themeColor.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(themeBackground.themeColor.opacity(0.05))
        .navigationTitle(rider.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RiderDetailView(
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
        .environment(RiderRouter(riderService: RiderDataService()))
        .environment(ThemeBackground())
    }
}
