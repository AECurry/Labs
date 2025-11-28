//
//  RepresentativeScreenContainer.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

struct RepresentativeScreenContainer: View {
    @State private var viewModel: RepresentativeViewModel
    
    init(apiController: RepAPIControllerProtocol = RepAPIController()) {
        _viewModel = State(wrappedValue: RepresentativeViewModel(apiController: apiController))
    }
    
    var body: some View {
        RepresentativeScreenView(viewModel: viewModel)
    }
}

#Preview {
    RepresentativeScreenContainer()
}

