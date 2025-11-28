//
//  DogDataModel.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import Foundation
import UIKit

// MARK: - Current Dog Display

struct CurrentDog: Equatable {
    let id = UUID()
    let image: UIImage
    var name: String
    
    init(image: UIImage, name: String = "") {
        self.image = image
        self.name = name
    }
}

// MARK: - Listed Dog (in Dogs Tab)
struct ListedDog: Identifiable, Equatable {
    let id: UUID  // Remove the = UUID() default value
    let image: UIImage
    var name: String
    let dateAdded: Date  // Remove any default value
    var isFavorite: Bool = false
    
    // Existing initializer for new dogs
    init(image: UIImage, name: String) {
        self.id = UUID()
        self.image = image
        self.name = name
        self.dateAdded = Date()
    }
    
    // NEW initializer for loading saved dogs - ADD THIS
    init(id: UUID, image: UIImage, name: String, dateAdded: Date, isFavorite: Bool = false) {
        self.id = id
        self.image = image
        self.name = name
        self.dateAdded = dateAdded
        self.isFavorite = isFavorite
    }
    
    init(from currentDog: CurrentDog) {
        self.id = UUID()
        self.image = currentDog.image
        self.name = currentDog.name.isEmpty ? "Unnamed Dog" : currentDog.name
        self.dateAdded = Date()
    }
}
// MARK: - Dog State

struct DogState {
    var currentDog: CurrentDog?
    var listedDogs: [ListedDog] = []
    var isLoading = false
    var error: String?
    
    // Helper to get only favorite dogs for Favorites tab
    var favoriteDogs: [ListedDog] {
        listedDogs.filter { $0.isFavorite }
    }
    
    var canMoveCurrentDogToList: Bool {
        currentDog != nil
    }
}

