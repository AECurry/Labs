//
//  RangedQuestionSubview.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct RangedQuestionSubview: View {
    @Environment(QuizViewModel.self) private var viewModel 
    @State private var sliderValue = 2.0
    
    var body: some View {
        ZStack {
            MagicalBackground()
            
            VStack(spacing: 30) {
                // BREADCRUMB AT VERY TOP - CENTERED
                VStack {
                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questionList.count)") // Updated
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                .padding(.top, 20)
                
                // Question Text
                Text(viewModel.currentQuestion.text) // Updated
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
                            if viewModel.currentQuestion.answers.indices.contains(answerIndex) { // Updated
                                viewModel.selectAnswer(viewModel.currentQuestion.answers[answerIndex]) // Updated
                            }
                        }
                    
                    HStack {
                        if viewModel.currentQuestion.answers.count > 0 { // Updated
                            Text(viewModel.currentQuestion.answers[0].text) // Updated
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        if viewModel.currentQuestion.answers.count > 3 { // Updated
                            Text(viewModel.currentQuestion.answers[3].text) // Updated
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
