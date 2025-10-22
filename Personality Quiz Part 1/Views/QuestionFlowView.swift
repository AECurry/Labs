//
//  QuestionFlowView.swift
//  Personality Quiz Part 1
//

import SwiftUI

struct QuestionFlowView: View {
    @Environment(QuizViewModel.self) private var quizManager
    
    var body: some View {
        // Show the appropriate question subview based on CURRENT question type
        Group {
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
}

#Preview {
    NavigationStack {
        QuestionFlowView()
            .environment(QuizViewModel())
    }
}
