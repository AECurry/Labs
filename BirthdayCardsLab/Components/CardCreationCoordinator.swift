//
//  CardCreationCoordinator.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class CardCreationCoordinator {
    var card = BirthdayCard()
    var currentStep: CreationStep = .title
    var path = NavigationPath()
    
    private var modelContext: ModelContext?
    
    func navigateToNextStep() {
        guard let nextStep = currentStep.next() else { return }
        currentStep = nextStep
        path.append(nextStep)
    }
    
    func navigateToPreviousStep() {
        guard let previousStep = currentStep.previous() else {
            if !path.isEmpty {
                path.removeLast()
            }
            return
        }
        currentStep = previousStep
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func saveCard() {
        guard let modelContext = modelContext else {
            print("Error: No ModelContext available")
            return
        }
        
        if card.themeColor == nil {
            card.themeColor = ThemeColor(color: .blue)
        }
        modelContext.insert(card)
        card = BirthdayCard()
        resetToFirstStep()
    }
    
    func resetToFirstStep() {
        currentStep = .title
        path = NavigationPath()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
}

enum CreationStep: Int, CaseIterable, Hashable {
    case title = 1
    case description
    case photo
    case date
    case color
    case preview
    
    var title: String {
        switch self {
        case .title: return "Create Your Birthday Card"
        case .description: return "Describe your party"
        case .photo: return "Add Photo"
        case .date: return "Select Date"
        case .color: return "Choose Color"
        case .preview: return "Preview"
        }
    }
    
    var instructions: String {
        switch self {
        case .title: return "Enter a catchy title for your birthday party"
        case .description: return "Describe what makes your party special"
        case .photo: return "Choose a photo that represents your party theme"
        case .date: return "Select the date and time of your party"
        case .color: return "Pick a background color for your card"
        case .preview: return "Review your card before saving"
        }
    }
    
    func next() -> CreationStep? {
        let allCases = CreationStep.allCases
        guard let currentIndex = allCases.firstIndex(of: self),
              currentIndex + 1 < allCases.count else {
            return nil
        }
        return allCases[currentIndex + 1]
    }
    
    func previous() -> CreationStep? {
        let allCases = CreationStep.allCases
        guard let currentIndex = allCases.firstIndex(of: self),
              currentIndex > 0 else {
            return nil
        }
        return allCases[currentIndex - 1]
    }
    
    @ViewBuilder
    func view() -> some View {
        // Wrap in Group to apply modifier once
        Group {
            switch self {
            case .title:
                TitleInputStepView()
            case .description:
                DescriptionInputStepView()
            case .photo:
                PhotoPickerStepView()
            case .date:
                DatePickerStepView()
            case .color:
                ColorPickerStepView()
            case .preview:
                CardPreviewStepView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
