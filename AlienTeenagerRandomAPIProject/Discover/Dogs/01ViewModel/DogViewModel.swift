//
//  DogViewModel.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

@Observable
class DogViewModel {
    // MARK: - Properties
    private let apiController: DogAPIControllerProtocol
    private let storage: DogStoring
    var state: DogState = DogState()
    
    // MARK: - Initialization
    init(
        apiController: DogAPIControllerProtocol = DogAPIController(),
        storage: DogStoring = DogStorageManager()
    ) {
        self.apiController = apiController
        self.storage = storage
        loadSavedDogs()
    }
    
    // MARK: - Private Methods
    private func loadSavedDogs() {
        if let savedDogs = storage.loadDogs() {
            state.listedDogs = savedDogs
        }
    }
    
    private func saveDogs() {
        storage.saveDogs(state.listedDogs)
    }
    
    // MARK: - Public Methods
    
    /// Fetches a new random dog image from the API
    func fetchNewDog() async {
        state.isLoading = true
        state.error = nil
        
        do {
            let image = try await apiController.fetchRandomDogImage()
            await MainActor.run {
                state.currentDog = CurrentDog(image: image)
                state.isLoading = false
            }
        } catch {
            await MainActor.run {
                state.error = error.localizedDescription
                state.isLoading = false
            }
        }
    }
    
    /// Updates the name of the current dog
    func updateCurrentDogName(_ newName: String) {
        state.currentDog?.name = newName
    }
    
    /// Saves the current dog to the list
    func saveCurrentDogToList() {
        guard let currentDog = state.currentDog else { return }
        let listedDog = ListedDog(from: currentDog)
        state.listedDogs.append(listedDog)
        state.currentDog = nil
        saveDogs()
    }
    
    /// Updates a dog in the list (used after editing in detail view)
    func updateDog(_ updatedDog: ListedDog) {
        if let index = state.listedDogs.firstIndex(where: { $0.id == updatedDog.id }) {
            state.listedDogs[index] = updatedDog
            saveDogs()
        }
    }
    
    /// Toggles the favorite status of a dog
    func toggleFavorite(for dogId: UUID) {
        guard let index = state.listedDogs.firstIndex(where: { $0.id == dogId }) else { return }
        state.listedDogs[index].isFavorite.toggle()
        saveDogs()
    }
    
    /// Removes a dog from the list
    func removeDog(_ dogId: UUID) {
        state.listedDogs.removeAll { $0.id == dogId }
        saveDogs()
    }
    
    /// Clears errors
    func clearError() {
        state.error = nil
    }
}

