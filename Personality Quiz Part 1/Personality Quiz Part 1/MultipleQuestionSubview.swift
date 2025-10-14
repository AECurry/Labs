//
//  MultipleQuestionSubview.swift
//  Personality Quiz Part 1
//

import SwiftUI

struct MultipleQuestionSubview: View {
    @Environment(QuizScreensManager.self) private var quizManager
    @State private var selectedAnswerIndex: Int? = nil // Change to single selection
    
    var body: some View {
        ZStack {
            MagicalBackground()
            
            VStack(spacing: 30) {
                // BREADCRUMB AT VERY TOP - CENTERED
                VStack {
                    Text("Question \(quizManager.currentQuestionIndex + 1) of \(quizManager.questionList.count)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                .padding(.top, 20)
                
                // Question Text
                Text(quizManager.currentQuestion.text)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Single selection list (changed from multiple)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<quizManager.currentQuestion.answers.count, id: \.self) { index in
                            Button(action: {
                                // Single selection logic - only one can be selected
                                selectedAnswerIndex = index
                                quizManager.selectAnswer(quizManager.currentQuestion.answers[index])
                            }) {
                                HStack {
                                    Text(quizManager.currentQuestion.answers[index].text)
                                        .foregroundColor(.white)
                                        .fontWeight(selectedAnswerIndex == index ? .bold : .regular) // Bold when selected
                                    Spacer()
                                    if selectedAnswerIndex == index {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                                .padding()
                                .background(selectedAnswerIndex == index ?
                                           Color.white.opacity(0.3) : // Highlight when selected
                                           Color.white.opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Bottom Navigation Buttons
                NavigationButtons()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        MultipleQuestionSubview()
            .environment(QuizScreensManager())
    }
}
