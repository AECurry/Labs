//
//  RepresentativeListSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

struct RepresentativeListSection: View {
    let representatives: [Representative]
    let hasSearched: Bool
    let searchedZipCode: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if representatives.isEmpty && hasSearched {
                    // Empty State
                    EmptyStateView(  // ✅ NO 'private' here - just call it normally
                        title: "No Representatives Found",
                        message: "No representatives found for zip code \(searchedZipCode). Please try another zip code.",
                        icon: "person.slash"
                    )
                } else if representatives.isEmpty {
                    // Initial State
                    EmptyStateView(  // ✅ NO 'private' here - just call it normally
                        title: "Search for Representatives",
                        message: "Enter a zip code above to find your representatives in Congress.",
                        icon: "person.2"
                    )
                } else {
                    // Results Header
                    HStack {
                        Text("Results for \(searchedZipCode)")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(representatives.count) found")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 4)
                    
                    // Representative Cards
                    ForEach(representatives) { representative in
                        RepresentativeListCell(representative: representative)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 180)
        }
    }
}

// ✅ ADD THIS AT THE BOTTOM - This is where 'private' goes!
private struct EmptyStateView: View {
    let title: String
    let message: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.alabasterGray.opacity(0.6))
        .cornerRadius(16)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        CustomGradientBkg2()
        RepresentativeListSection(
            representatives: [
                Representative(
                    name: "John Smith",
                    party: "D",
                    state: "UT",
                    district: "3",
                    phone: "202-555-0123",
                    office: "123 Capitol Building",
                    link: "https://example.com"
                )
            ],
            hasSearched: true,
            searchedZipCode: "84043"
        )
    }
}
