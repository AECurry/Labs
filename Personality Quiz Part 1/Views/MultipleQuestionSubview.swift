//
//  MultipleQuestionSubview.swift
//  Personality Quiz Part 1
//

import SwiftUI

struct MultipleQuestionSubview: View {
    @Environment(QuizViewModel.self) private var viewModel 
    @State private var selectedAnswerIndex: Int? = nil
    
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
                
                // Single selection list
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<viewModel.currentQuestion.answers.count, id: \.self) { index in // Updated
                            Button(action: {
                                selectedAnswerIndex = index
                                viewModel.selectAnswer(viewModel.currentQuestion.answers[index]) // Updated
                            }) {
                                HStack {
                                    Text(viewModel.currentQuestion.answers[index].text) // Updated
                                        .foregroundColor(.white)
                                        .fontWeight(selectedAnswerIndex == index ? .bold : .regular)
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
                                           Color.white.opacity(0.3) :
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
