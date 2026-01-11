//
//  PantsSectionView.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI

struct PantsSectionView: View {
    let pants: [Clothing]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Pants")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(
                    rows: [
                        GridItem(.adaptive(minimum: 70)),
                        GridItem(.adaptive(minimum: 70)),
                        GridItem(.adaptive(minimum: 70)),
                        GridItem(.adaptive(minimum: 70))
                    ],
                    spacing: 12
                ) {
                    ForEach(pants) { pant in
                        ClothingCardView(clothing: pant, width: 70)
                            .frame(height: 70)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal)
            }
            .scrollTargetBehavior(.paging)
            .frame(height: 320)
        }
    }
}
