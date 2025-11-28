//
//  DogStorageManager.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import Foundation
import UIKit

// MARK: - Protocol
protocol DogStoring {
    func saveDogs(_ dogs: [ListedDog])
    func loadDogs() -> [ListedDog]?
}

// MARK: - Implementation
class DogStorageManager: DogStoring {
    private let savedDogsKey = "savedDogs"
    
    func saveDogs(_ dogs: [ListedDog]) {
        let savableDogs = dogs.map { SavableDog(from: $0) }
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(savableDogs)
            UserDefaults.standard.set(encodedData, forKey: savedDogsKey)
        } catch {
            print("Error saving dogs: \(error)")
        }
    }
    
    func loadDogs() -> [ListedDog]? {
        guard let data = UserDefaults.standard.data(forKey: savedDogsKey) else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let savableDogs = try decoder.decode([SavableDog].self, from: data)
            return savableDogs.compactMap { createListedDog(from: $0) }
        } catch {
            print("Error loading dogs: \(error)")
            return nil
        }
    }
    
    // MARK: - Private Helper
    private func createListedDog(from savableDog: SavableDog) -> ListedDog? {
        guard let imageData = savableDog.imageData,
              let image = UIImage(data: imageData) else { return nil }
        
        // Use the new initializer to restore all properties
        let dog = ListedDog(
            id: savableDog.id,
            image: image,
            name: savableDog.name,
            dateAdded: savableDog.dateAdded,
            isFavorite: savableDog.isFavorite
        )
        return dog
    }
}

// MARK: - Helper Types
struct SavableDog: Codable {
    let id: UUID
    let imageData: Data?
    let name: String
    let dateAdded: Date
    let isFavorite: Bool
    
    init(from dog: ListedDog) {
        self.id = dog.id
        self.imageData = dog.image.jpegData(compressionQuality: 0.8)
        self.name = dog.name
        self.dateAdded = dog.dateAdded
        self.isFavorite = dog.isFavorite
    }
}
