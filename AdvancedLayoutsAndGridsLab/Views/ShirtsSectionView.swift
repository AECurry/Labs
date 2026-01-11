//
//  ShirtsSectionView.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI

struct ShirtsSectionView: View {
    let shirts: [Clothing]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Shirts")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(
                    rows: [
                        GridItem(.fixed(120)),
                        GridItem(.fixed(120))
                    ],
                    spacing: 15
                ) {
                    ForEach(shirts) { shirt in
                        ClothingCardView(clothing: shirt, width: 140)
                            .frame(height: 120)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal)
            }
            // No .scrollTargetBehavior for FREE scrolling
            .frame(height: 260)
        }
    }
}
