//
//  HatsSectionView.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI

struct HatsSectionView: View {
    let hats: [Clothing]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hats")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(hats) { hat in
                        ClothingCardView(clothing: hat, width: 150)
                            .frame(height: 150)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal)
            }
            .scrollTargetBehavior(.viewAligned)
            .frame(height: 180)
        }
    }
}
