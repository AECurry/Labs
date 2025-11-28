//
//  NobelPrizeContentStack.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import SwiftUI

struct NobelPrizeContentStack: View {
    let viewModel: NobelPrizeViewModel
    
    @State private var yearInput: String = ""
    @State private var categoryInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // ========== COMPACT HEADER SECTION ==========
            VStack(spacing: 16) { // Reduced spacing
                // Title text - more compact
                Text("Nobel Prize Winners")
                    .font(.system(size: 24, weight: .bold)) // Slightly smaller
                    .foregroundColor(.white)
                    .padding(.top, 32)
                
                // Search section
                NobelSearchSection(
                    yearInput: $yearInput,
                    categoryInput: $categoryInput,
                    categories: viewModel.state.categories,
                    isLoading: viewModel.state.isLoading,
                    onSearch: {
                        Task {
                            await viewModel.searchPrizes(year: yearInput, category: categoryInput)
                        }
                    },
                    onClearSearch: {
                        yearInput = ""
                        categoryInput = ""
                        viewModel.clearSearch()
                    }
                )
                
                // Error message
                if let error = viewModel.state.error {
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .background(Color.clear)
            
            // ========== SCROLLABLE RESULTS SECTION ==========
            NobelListSection(
                nobelPrizes: viewModel.state.nobelPrizes,
                hasSearched: viewModel.state.hasSearched,
                searchSummary: viewModel.displaySearchSummary
            )
        }
        .ignoresSafeArea(.keyboard)
        .task {
            await viewModel.loadInitialData()
        }
    }
}
