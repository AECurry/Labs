//
//  TitleInputStepView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct TitleInputStepView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        VStack(spacing: 24) {
            // Progress dots at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            .padding(.top, 10)
            
            // Instructions
            Text("What's the name of your party?")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            // Text input
            TextField("Enter party title...", text: $coordinator.card.cardTitle)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            
            // Character count
            HStack {
                Spacer()
                Text("\(coordinator.card.cardTitle.count)/50")
                    .font(.caption)
                    .foregroundColor(coordinator.card.cardTitle.count > 50 ? .red : .gray)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Validation feedback
            if coordinator.card.cardTitle.isEmpty {
                Text("Title is required")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            // Navigation buttons at bottom
            StepNavigationView()
                .padding(.bottom)
        }
        .padding()
        .navigationTitle("Create Your Birthday Card")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let coordinator = CardCreationCoordinator()
    coordinator.card.cardTitle = "Sample Party"
    
    return TitleInputStepView()
        .environment(coordinator)
}
