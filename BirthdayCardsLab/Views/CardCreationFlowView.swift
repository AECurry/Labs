//
//  CardCreationFlowView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI
import SwiftData

struct CardCreationFlowView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress indicator at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            
            Spacer()
            
            // Card preview - LARGER
            CardTemplatePreview(
                card: coordinator.card,
                currentStep: coordinator.currentStep.rawValue
            )
            .padding(.horizontal)
            
            Spacer()
            
            // Minimal guidance
            if coordinator.path.isEmpty {
                VStack(spacing: 10) {
                    
                    Text("Tap 'Next' to begin customizing")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            } else {
                Spacer()
                    .frame(height: 20)
            }
            
            // Navigation buttons at bottom - USING REUSABLE COMPONENT
            StepNavigationView()
        }
        .navigationTitle(coordinator.currentStep.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            coordinator.setModelContext(modelContext)
        }
    }
}

#Preview {
    let coordinator = CardCreationCoordinator()
    
    return CardCreationFlowView()
        .environment(coordinator)
}
