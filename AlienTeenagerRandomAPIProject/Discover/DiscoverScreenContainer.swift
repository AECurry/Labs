//
//  DiscoverScreenContainer.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/22/25.
//

import SwiftUI

struct DiscoverScreenContainer: View {
    let resetTrigger: Bool
    @State private var selectedFeature: String? = nil
    
    var body: some View {
        ZStack {
            if selectedFeature == "dogs" {
                DogScreenContainer()
            } else if selectedFeature == "reps" {
                RepresentativeScreenContainer()
            } else if selectedFeature == "nobel" {
                NobelPrizeScreenView(
                    viewModel: NobelPrizeViewModel(
                        apiController: NobelAPIController() // ← USE REAL API NOW!
                    )
                )
            } else {
                DiscoverScreenView(
                    onDogsTapped: { selectedFeature = "dogs" },
                    onRepresentativesTapped: { selectedFeature = "reps" },
                    onNobelTapped: { selectedFeature = "nobel" }
                )
            }
        }
        .onChange(of: resetTrigger) { oldValue, newValue in
            selectedFeature = nil  // Reset to main Discover view
        }
    }
}

#Preview {
    DiscoverScreenContainer(resetTrigger: false)
}
