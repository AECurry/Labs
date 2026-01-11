//
//  ClothingCardView.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import SwiftUI

struct ClothingCardView: View {
    let clothing: Clothing
    let width: CGFloat
    // REMOVE: let height: CGFloat
    
    var body: some View {
        let colors = ColorHelper.colorFromString(clothing.color)
        
        ZStack {
            // Solid colored background
            colors.background
                .cornerRadius(10)
            
            // Text content
            VStack(alignment: .leading, spacing: 6) {
                // Name - TOP
                Text(clothing.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colors.text)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Price and Color - BOTTOM
                VStack(alignment: .leading, spacing: 2) {
                    Text(clothing.formattedPrice)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(colors.text)
                    
                    Text(clothing.color)
                        .font(.system(size: 12))
                        .foregroundColor(colors.text.opacity(0.9))
                }
            }
            .padding(10)
            .frame(width: width)
        }
        .frame(width: width)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
    }
}
