//
//  DogListSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct DogListSection: View {
    let listedDogs: [ListedDog]
    let onFavoriteTapped: (UUID) -> Void
    let onDogTapped: (ListedDog) -> Void
    let onDeleteDog: (UUID) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if listedDogs.isEmpty {
                    EmptyStateView(
                        title: "No Dogs Yet",
                        message: "Generate and save dogs to see them here!",
                        icon: "pawprint"
                    )
                } else {
                    ForEach(listedDogs) { dog in
                        DogListCell(
                            dog: dog,
                            onFavoriteTapped: {
                                onFavoriteTapped(dog.id)
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onDogTapped(dog)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                onDeleteDog(dog.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollTargetLayout()
        .scrollTargetBehavior(.viewAligned)
        .safeAreaInset(edge: .top) { Color.clear.frame(height: 16) }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 180) } // Stops above tab bar
    }
}

// ADD THIS EMPTY STATE VIEW AT THE BOTTOM OF THE SAME FILE
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

