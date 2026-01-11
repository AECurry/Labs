//
//  BirthdayCardsMainView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

//  Main parent file for the whole app must stay dumb
import SwiftUI

struct BirthdayCardsMainView: View {
    @State private var coordinator = CardCreationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // Initial view when app starts
            CardCreationFlowView()
                .navigationDestination(for: CreationStep.self) { step in
                    // Each step view will be pushed onto the stack
                    step.view()
                        .environment(coordinator)
                }
        }
        .environment(coordinator)
    }
}

#Preview {
    BirthdayCardsMainView()
        .environment(CardCreationCoordinator())
}
