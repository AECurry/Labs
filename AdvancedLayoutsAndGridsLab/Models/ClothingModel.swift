//
//  ClothingModel.swift
//  AdvancedLayoutsAndGridsLab
//
//  Created by AnnElaine on 1/7/26.
//

import Foundation

struct Clothing: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let size: String
    let color: String
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
}
