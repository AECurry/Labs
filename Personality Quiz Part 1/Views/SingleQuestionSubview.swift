//
//  SingleQuestionSubview.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct SingleQuestionSubview: View {
    @Environment(QuizViewModel.self) private var viewModel 
    @State private var selectedAnswerIndex = 0
    
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
                
                // Picker for single selection
                Picker("Select an answer", selection: $selectedAnswerIndex) {
                    ForEach(0..<viewModel.currentQuestion.answers.count, id: \.self) { index in // Updated
                        Text(viewModel.currentQuestion.answers[index].text) // Updated
                            .foregroundColor(.white)
                            .fontWeight(selectedAnswerIndex == index ? .bold : .regular)
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .onChange(of: selectedAnswerIndex) {
                    viewModel.selectAnswer(viewModel.currentQuestion.answers[selectedAnswerIndex]) // Updated
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
