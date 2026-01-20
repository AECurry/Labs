//
//  PhotoScrollView.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/20/26.
//

import SwiftUI

struct PhotoScrollView: View {
    let photos: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 12) {
                ForEach(photos.indices, id: \.self) { index in
                    Image(uiImage: photos[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 2)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 120)
    }
}
