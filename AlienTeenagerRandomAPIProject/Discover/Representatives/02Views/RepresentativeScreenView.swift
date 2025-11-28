//
//  RepresentativeScreenView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

struct RepresentativeScreenView: View {
    let viewModel: RepresentativeViewModel
    
    var body: some View {
        ZStack {
            CustomGradientBkg2()
            
            RepresentativeContentStack(
                representatives: viewModel.state.representatives,
                isLoading: viewModel.state.isLoading,
                error: viewModel.state.error,
                hasSearched: viewModel.state.hasSearched,
                searchedZipCode: viewModel.state.searchedZipCode,
                onSearch: { zipCode in
                    Task {
                        await viewModel.searchRepresentatives(zipCode: zipCode)
                    }
                }
            )
        }
    }
}

// MARK: - Preview
#Preview {
    RepresentativeScreenView(
        viewModel: RepresentativeViewModel(
            apiController: RepAPIController()
        )
    )
}
