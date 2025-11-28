//
//  DogListCell.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct DogListCell: View {
    let dog: ListedDog
    let onFavoriteTapped: () -> Void   // Not optional — makes things cleaner

    var body: some View {
        HStack(spacing: 16) {
            Image(uiImage: dog.image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(dog.name)
                    .font(.headline)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: onFavoriteTapped) {
                Image(systemName: dog.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(dog.isFavorite ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Color.alabasterGray.opacity(0.8))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        CustomGradientBkg2()
        DogListCell(
            dog: ListedDog(
                image: UIImage(systemName: "photo")!,
                name: "Buddy"
            ),
            onFavoriteTapped: { }
        )
        .padding()
    }
}

