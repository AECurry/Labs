//
//  DogContentStack.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct DogContentStack: View {
    let viewModel: DogViewModel  // Receive the whole viewModel
    @Binding var showingDogDetail: ListedDog?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // FIXED HEADER
                VStack(spacing: 24) {
                    DogHeaderSection(
                        currentDog: viewModel.state.currentDog,
                        isLoading: viewModel.state.isLoading,
                        canSave: viewModel.state.canMoveCurrentDogToList,
                        onNameChange: { viewModel.updateCurrentDogName($0) },
                        onNewImageTapped: {
                            Task { await viewModel.fetchNewDog() }
                        },
                        onSaveToListTapped: { viewModel.saveCurrentDogToList() }
                    )
                    .padding(.horizontal, 24)
                }
                .frame(height: geometry.size.height * 0.4)
                .padding(.top, geometry.safeAreaInsets.top + 60)
                .padding(.bottom, 20)
                .background(Color.clear)
                
                // SCROLLABLE LIST
                DogListSection(
                    listedDogs: viewModel.state.listedDogs,
                    onFavoriteTapped: { viewModel.toggleFavorite(for: $0) },
                    onDogTapped: { dog in
                        showingDogDetail = dog
                    },
                    onDeleteDog: { viewModel.removeDog($0) }
                )
                .frame(height: geometry.size.height * 0.6)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .task {
            if viewModel.state.currentDog == nil && !viewModel.state.isLoading {
                await viewModel.fetchNewDog()
            }
        }
    }
}
