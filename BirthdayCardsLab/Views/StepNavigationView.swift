//
//  StepNavigationView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct StepNavigationView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        VStack(spacing: 0) {
            HStack {
                if coordinator.currentStep.rawValue > 1 {
                    Button(action: { coordinator.navigateToPreviousStep() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .frame(minWidth: 100)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                } else {
                    // Spacer to balance layout when no Back button
                    Spacer()
                        .frame(minWidth: 100)
                }
                
                Spacer()
                    .frame(width: 20)
                
                if coordinator.currentStep != .preview {
                    Button(action: { coordinator.navigateToNextStep() }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .frame(minWidth: 100)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.trailing, 16)
                } else {
                    Button("Save & Share") {
                        coordinator.saveCard()
                    }
                    .frame(minWidth: 100)
                    .padding(.vertical, 12)
                    .buttonStyle(.borderedProminent)
                    .padding(.trailing, 16)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    let coordinator = CardCreationCoordinator()
    coordinator.currentStep = .description
    
    return StepNavigationView()
        .environment(coordinator)
}
