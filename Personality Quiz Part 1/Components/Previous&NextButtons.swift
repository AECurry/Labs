//
//  Previous&NextButtons.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct NavigationButtons: View {
    
    @Environment(QuizViewModel.self) private var quizManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 20) {
            // Previous Button - Only show if not first question
            if !quizManager.isFirstQuestion {
                Button(action: {
                    quizManager.goToPreviousQuestion()
                }) {
                    Text("Previous")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.indigo)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .white.opacity(0.6), radius: 12, x: 0, y: 6)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            } else {
                // Invisible spacer to maintain layout when Previous is hidden
                Spacer()
                    .frame(maxWidth: .infinity, minHeight: 50)
            }
            
            // Next/Results Button - Show different text AND behavior on last question
            if quizManager.isLastQuestion {
                NavigationLink(destination: ResultsView().environment(quizManager)) {
                    Text("See Results")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.indigo)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .white.opacity(0.6), radius: 12, x: 0, y: 6)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            } else {
                Button(action: {
                    quizManager.goToNextQuestion()
                }) {
                    Text("Next")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.indigo)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: .white.opacity(0.6), radius: 12, x: 0, y: 6)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(!quizManager.isCurrentQuestionAnswered)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
}

#Preview {
    ZStack {
        MagicalBackground()
        NavigationButtons()
            .environment(QuizViewModel())
    }
}
