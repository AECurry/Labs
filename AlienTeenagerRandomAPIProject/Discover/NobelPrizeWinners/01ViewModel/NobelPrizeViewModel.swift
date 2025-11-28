//
//  NobelPrizeViewModel.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import SwiftUI

@Observable
class NobelPrizeViewModel {
    // MARK: - Properties
    private let apiController: NobelAPIControllerProtocol
    var state: NobelPrizeState = NobelPrizeState()
    
    // MARK: - Initialization
    init(apiController: NobelAPIControllerProtocol = NobelAPIController()) {
        self.apiController = apiController
    }
    
    // MARK: - Public Methods
    
    /// Fetches Nobel prizes with current search filters
    func fetchNobelPrizes() async {
        state.isLoading = true
        state.error = nil
        
        do {
            let nobelPrizes = try await apiController.fetchNobelPrizes(
                year: state.searchYear.isEmpty ? nil : state.searchYear,
                category: state.selectedCategory.isEmpty ? nil : state.selectedCategory,
                limit: 50
            )
            
            await MainActor.run {
                state.nobelPrizes = nobelPrizes
                state.hasSearched = true
                state.isLoading = false
            }
        } catch {
            await MainActor.run {
                state.error = error.localizedDescription
                state.nobelPrizes = []
                state.hasSearched = true
                state.isLoading = false
            }
        }
    }
    
    /// Fetches available categories
    func fetchCategories() async {
        do {
            let categories = try await apiController.fetchCategories()
            await MainActor.run {
                state.categories = categories
            }
        } catch {
            await MainActor.run {
                state.error = "Failed to load categories: \(error.localizedDescription)"
            }
        }
    }
    
    /// Searches with specific year and category
    func searchPrizes(year: String, category: String) async {
        state.searchYear = year
        state.selectedCategory = category
        await fetchNobelPrizes()
    }
    
    /// Clears the current search results
    func clearSearch() {
        state.nobelPrizes = []
        state.searchYear = ""
        state.selectedCategory = ""
        state.hasSearched = false
        state.error = nil
    }
    
    /// Clears any errors
    func clearError() {
        state.error = nil
    }
    
    /// Loads initial data (categories)
    func loadInitialData() async {
        await fetchCategories()
    }
    
    // MARK: - Computed Properties
    
    var canSearch: Bool {
        !state.searchYear.isEmpty || !state.selectedCategory.isEmpty
    }
    
    var displaySearchSummary: String {
        var parts: [String] = []
        
        if !state.searchYear.isEmpty {
            parts.append("Year: \(state.searchYear)")
        }
        
        if !state.selectedCategory.isEmpty {
            parts.append("Category: \(state.selectedCategory.capitalized)")
        }
        
        if parts.isEmpty {
            return "All Nobel Prizes"
        }
        
        return parts.joined(separator: " • ")
    }
}

