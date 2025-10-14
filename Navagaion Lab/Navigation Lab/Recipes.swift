//
//  Recipes.swift
//  Navigation Lab
//
//  Created by AnnElaine on 10/8/25.
//

import Foundation
import SwiftUI

struct Recipes: Identifiable, Equatable, Hashable {
    let id = UUID()
    var name: String
    var ingredients: [String]
    var instructions: [String]
    var imageData: Data? = nil
    
    var image: Image? {
        if let data = imageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    static func == (lhs: Recipes, rhs: Recipes) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
