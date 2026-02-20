//
//  WalkSetupView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct WalkSetupViewSimple: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = WalkSetupViewModel()
    
    let onStartSession: (DurationOption, MusicOption) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    WalkSetupHeader(onBack: {
                        dismiss()
                        onDismiss()
                    })
                    .padding(.top, 0)
                    
                    WalkSetupTitle()
                        .padding(.top, 0)
                        .padding(.bottom, 0)
                    
                    WalkSetupImageAreaView()
                        .padding(.bottom, 0)
                    
                    DurationDropdown(selectedDuration: $viewModel.selectedDuration)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    
                    MusicDropdown(selectedMusic: $viewModel.selectedMusic)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    LetsGoButton(
                        isEnabled: viewModel.isReadyToStart,
                        action: {
                            viewModel.startWalkingSession()
                            onStartSession(viewModel.selectedDuration, viewModel.selectedMusic)
                        }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    WalkSetupViewSimple(
        onStartSession: { _, _ in print("Start") },
        onDismiss: { print("Dismiss") }
    )
}

