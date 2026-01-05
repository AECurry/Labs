//
//  RankingRow.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

struct RankingRow: View {
    let rank: Int
    let displayName: String
    let subtitle: String
    let points: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank number
            Text("\(rank)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(rankColor)
                .frame(width: 30)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(displayName)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.fnWhite)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.fnWhite)
            }
            
            Spacer()
            
            // Points
            VStack(alignment: .trailing) {
                Text("\(points)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.fnWhite)
                
                Text("points")
                    .font(.caption2)
                    .foregroundColor(.fnWhite)
            }
        }
        .padding()
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .fnGold
        case 2: return .fnSilver
        case 3: return .fnBronze
        default: return .fnGray1
        }
    }
}

