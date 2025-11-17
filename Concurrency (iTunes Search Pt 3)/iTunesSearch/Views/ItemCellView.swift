//
//  ItemCellView.swift
//  iTunesSearch
//
//  Created by AnnElaine on 11/3/25.
//

import SwiftUI

struct ItemCellView: View {
    let item: StoreItem
    let onPlayButtonPressed: () -> Void

    var body: some View {
        HStack {
            if let url = item.artworkURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 75, height: 75)
                .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.artist)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            if item.previewUrl != nil {
                Button(action: onPlayButtonPressed) {
                    Image(systemName: "play.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
}
