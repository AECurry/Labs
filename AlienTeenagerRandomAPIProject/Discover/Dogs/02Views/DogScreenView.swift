//
//  DogScreenView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct DogScreenView: View {
    let viewModel: DogViewModel
    @State private var showingDogDetail: ListedDog?
    
    var body: some View {
        ZStack {
            CustomGradientBkg2()
            
            DogContentStack(
                viewModel: viewModel,  
                showingDogDetail: $showingDogDetail
            )
        }
        .sheet(item: $showingDogDetail) { dog in
            DogDetailView(dog: dog) { updatedDog in
                viewModel.updateDog(updatedDog)
            }
        }
        .task {
            if viewModel.state.currentDog == nil && !viewModel.state.isLoading {
                await viewModel.fetchNewDog()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DogScreenView(viewModel: DogViewModel(apiController: DogAPIController()))
    }
}
