//
//  QuestionFlowView.swift
//  Personality Quiz Part 1
//

import SwiftUI

struct QuestionFlowView: View {
    @Environment(QuizScreensManager.self) private var quizManager
    
    var body: some View {
        ZStack {
            MagicalBackground()
            
            VStack {
                // Dynamic question display based on type
                switch quizManager.currentQuestion.type {
                case .single:
                    SingleQuestionSubview()
                case .multiple:
                    MultipleQuestionSubview()
                case .ranged:
                    RangedQuestionSubview()
                case .card:
                    CardQuestionSubview()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: String.self) { _ in
            ResultsView()
                .environment(quizManager) // ← ADD THIS LINE
        }
    }
}

#Preview {
    NavigationStack {
        QuestionFlowView()
            .environment(QuizScreensManager())
    }
}
