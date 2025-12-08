//
//  MainAppView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

import SwiftUI

/// The main container view for the countdown animation app.
struct MainAppView: View {
    
    /// The shared ViewModel that manages countdown logic and animation state.
    @State private var viewModel = CountdownViewModel()
    
    /// Main Layout
    var body: some View {
        ZStack {
            
            //Full-screen black bachround
            Color.black
                .ignoresSafeArea()
            
            
            /// Vertical stack of all UI components
            VStack(spacing: 50) {
                Text("Game Countdown")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                
                /// Animation Container
                ///  The area where countdown numbers and "Go!" animate
                CountdownAnimationView(viewModel: viewModel)  // Pass viewModel
                    .frame(height: 200)
                
                Spacer()
                
                
                /// Game Controls
                /// The start button and game status display
                GameStartView(
                    shouldShowGetReady: viewModel.shouldShowGetReady,
                    isCountdownActive: viewModel.isCountdownActive,
                    onStartTapped: viewModel.startCountdown
                )
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    MainAppView()
}
