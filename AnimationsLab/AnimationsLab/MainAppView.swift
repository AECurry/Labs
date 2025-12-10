//
//  MainAppView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

// Parent View: Owns the ViewModel and coordinates all child views
// Responsible for: Layout, state management, passing data to children views
import SwiftUI

/// The main container view for the countdown animation app.
struct MainAppView: View {
    // STATE OWNERSHIP: ViewModel lives here and is passed to children
    @State private var viewModel = CountdownViewModel()
    
    var body: some View {
        ZStack {
            // Layer 1: Background (always visible)
            AppBackgroundView.gameStyle
            
            // Layer 2: Content
            VStack(spacing: 0) {
                // Header
                headerView
                
                Spacer()
                
                // Main animation area - COMPOSED of two child views
                animationAreaView
                
                Spacer()
                
                // Footer - conditional content
                footerView
            }
        }
    }
    
    // Subviews (Private helpers for readability)
    
    private var headerView: some View {
        Text("Game Countdown")
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .padding(.top, 56)
    }
    
    // COMPOSITION: Two child views layered together
    // SymbolCountdownView = background animations
    // CountdownAnimationView = foreground numbers/text
    private var animationAreaView: some View {
        ZStack {
            // Background layer: Symbols/stars
            SymbolCountdownView(viewModel: viewModel)
                .frame(height: 400)
            
            // Foreground layer: Numbers and GO! text
            CountdownAnimationView(viewModel: viewModel)
                .frame(height: 400)
        }
    }
    
    // CONDITIONAL RENDERING: Only shows when countdown is NOT active
    private var footerView: some View {
        Group {
            if !viewModel.isCountdownActive && !viewModel.showGoText {
                Button(action: viewModel.startCountdown) {
                    Text("Start Game")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    MainAppView()
}
