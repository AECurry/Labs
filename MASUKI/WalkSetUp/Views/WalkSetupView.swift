//
//  WalkSetupView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

//  Main parent file for the WalkSetUp folder
import SwiftUI

struct WalkSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WalkSetupViewModel()
    @State private var showWalkSession = false  // ADD THIS LINE
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with back button
                    WalkSetupHeader(onBack: { dismiss() })
                        .padding(.top, 0)
                    
                    // Title
                    WalkSetupTitle()
                        .padding(.top, 0)
                        .padding(.bottom, 0)
                    
                    // Animated Image
                    WalkSetupImageAreaView()
                        .padding(.bottom, 0)
                    
                    // Duration Selection
                    DurationDropdown(selectedDuration: $viewModel.selectedDuration)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    
                    // Music Selection (inactive)
                    MusicSelector(selectedMusic: $viewModel.selectedMusic)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    // LetsGo Button - UPDATED to show WalkSessionView
                    LetsGoButton(
                        isEnabled: viewModel.isReadyToStart,
                        action: {
                            viewModel.startWalkingSession()
                            showWalkSession = true
                        }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showWalkSession) {  // ADD THIS
            WalkSessionView(
                duration: viewModel.selectedDuration,
                music: viewModel.selectedMusic
            )
        }
    }
}

#Preview {
    WalkSetupView()
}
