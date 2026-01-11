//
//  CardCreationViewModel.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class CardCreationViewModel {
    var card = BirthdayCard()
    var modelContext: ModelContext?  // Accessible from view
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    func saveCard() {
        guard let modelContext = modelContext else {
            print("Error: ModelContext is nil")
            return
        }
        
        // Ensure themeColor exists
        if card.themeColor == nil {
            card.themeColor = ThemeColor(color: .blue)
        }
        
        modelContext.insert(card)
        
        // Reset for next card (create new instance)
        card = BirthdayCard()
    }
    
    func validateTitle() -> Bool {
        !card.cardTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func validateDate() -> Bool {
        card.date > Date()
    }
}
