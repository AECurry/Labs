//
//  CountdownRootView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

import SwiftUI

/// The main screen of the app - brings everything together.
/// This is the parent view that contains all other components.
struct CountdownRootView: View {
    // Our "brain" that manages the countdown logic
    @State private var viewModel = CountdownViewModel()
    
    var body: some View {
        ZStack {
            // Black background for game-like feel
            Color.black
                .ignoresSafeArea()  // Fill entire screen
            
            VStack(spacing: 50) {
                // App title at top
                Text("Game Countdown")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                // Where the 3-2-1-GO! animation happens
                CountdownAnimationView(viewModel: viewModel)
                    .frame(height: 200)  // Fixed height for animation area
                
                Spacer()
                
                // Start button and game status
                // UPDATE THESE PARAMETERS:
                GameStartView(
                    shouldShowGetReady: viewModel.shouldShowGetReady,  // ADD THIS
                    isCountdownActive: viewModel.isCountdownActive,
                    onStartTapped: viewModel.startCountdown
                )
                .padding(.bottom, 50)
            }
        }
    }
}

