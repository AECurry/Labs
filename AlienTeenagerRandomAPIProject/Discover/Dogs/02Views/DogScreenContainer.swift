//
//  DogScreenContainer.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/22/25.
//

import SwiftUI

struct DogScreenContainer: View {
    @State private var viewModel: DogViewModel
    
    init(apiController: DogAPIControllerProtocol = DogAPIController()) {
        _viewModel = State(wrappedValue: DogViewModel(apiController: apiController))
    }
    
    var body: some View {
        DogScreenView(viewModel: viewModel)
    }
}

#Preview {
    DogScreenContainer()
}

