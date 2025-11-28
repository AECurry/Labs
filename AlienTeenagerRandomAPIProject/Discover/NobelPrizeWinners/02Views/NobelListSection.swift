//
//  NobelListSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import SwiftUI

struct NobelListSection: View {
    let nobelPrizes: [NobelPrize]
    let hasSearched: Bool
    let searchSummary: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) { // Reduced spacing
                if hasSearched && nobelPrizes.isEmpty {
                    // Empty State
                    EmptyStateView(
                        title: "No Nobel Prizes Found",
                        message: "Try different search criteria",
                        icon: "trophy.slash"
                    )
                } else if !hasSearched {
                    // Initial State
                    EmptyStateView(
                        title: "Search for Nobel Prizes",
                        message: "Enter a year and/or select a category",
                        icon: "trophy"
                    )
                } else {
                    // Results Header - make it more compact
                    VStack(alignment: .leading, spacing: 4) {
                        Text(searchSummary)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Add a subtle separator
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 1)
                            .padding(.vertical, 4)
                    }
                    .padding(.horizontal)
                    
                    // Nobel Prize Cards - This is what displays the card view
                    ForEach(nobelPrizes) { prize in
                        NobelPrizeCardView(prize: prize)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 4) // Minimal top padding
        }
        // Remove the large bottom safe area inset
    }
}

// MARK: - Empty State View
private struct EmptyStateView: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) { // Reduced spacing
            Image(systemName: icon)
                .font(.system(size: 40)) // Smaller icon
                .foregroundColor(.gray)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}
