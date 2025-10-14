//
//  RangedQuestionSubview.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct RangedQuestionSubview: View {
    @Environment(QuizScreensManager.self) private var quizManager
    @State private var sliderValue = 2.0
    
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
                
                // Slider
                VStack(spacing: 20) {
                    Slider(value: $sliderValue, in: 1...4, step: 1)
                        .accentColor(.white)
                        .onChange(of: sliderValue) { oldValue, newValue in
                            let answerIndex = Int(newValue) - 1
                            if quizManager.currentQuestion.answers.indices.contains(answerIndex) {
                                quizManager.selectAnswer(quizManager.currentQuestion.answers[answerIndex])
                            }
                        }
                    
                    HStack {
                        if quizManager.currentQuestion.answers.count > 0 {
                            Text(quizManager.currentQuestion.answers[0].text)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        if quizManager.currentQuestion.answers.count > 3 {
                            Text(quizManager.currentQuestion.answers[3].text)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .padding(.horizontal)
                
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
        RangedQuestionSubview()
            .environment(QuizScreensManager())
    }
}
