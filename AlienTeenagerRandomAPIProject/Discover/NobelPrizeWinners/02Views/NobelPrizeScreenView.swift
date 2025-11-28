//
//  NobelPrizeScreenView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import SwiftUI

struct NobelPrizeScreenView: View {
    let viewModel: NobelPrizeViewModel
    
    var body: some View {
        ZStack {
            CustomGradientBkg2()
            
            NobelPrizeContentStack(
                viewModel: viewModel  // ✅ Just pass the viewModel once
            )
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Preview
#Preview {
    NobelPrizeScreenView(
        viewModel: NobelPrizeViewModel(
            apiController: NobelAPIController()
        )
    )
}
