//
//  RepresentativeViewModel.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

@Observable
class RepresentativeViewModel {
    // MARK: - Properties
    private let apiController: RepAPIControllerProtocol
    var state: RepresentativeState = RepresentativeState()
    
    // MARK: - Initialization
    init(apiController: RepAPIControllerProtocol = RepAPIController()) {
        self.apiController = apiController
    }
    
    // MARK: - Public Methods
    
    /// Searches for representatives by zip code
    func searchRepresentatives(zipCode: String) async {
        // Clear previous results
        state.isLoading = true
        state.error = nil
        state.searchedZipCode = zipCode
        
        do {
            let representatives = try await apiController.fetchRepresentatives(for: zipCode)
            await MainActor.run {
                state.representatives = representatives
                state.hasSearched = true
                state.isLoading = false
            }
        } catch {
            await MainActor.run {
                state.error = error.localizedDescription
                state.representatives = []
                state.hasSearched = true
                state.isLoading = false
            }
        }
    }
    
    /// Clears the current search results
    func clearSearch() {
        state.representatives = []
        state.searchedZipCode = ""
        state.hasSearched = false
        state.error = nil
    }
    
    /// Clears any errors
    func clearError() {
        state.error = nil
    }
}
