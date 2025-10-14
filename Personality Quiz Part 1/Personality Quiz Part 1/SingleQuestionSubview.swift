//
//  SingleQuestionSubview.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct SingleQuestionSubview: View {
    @Environment(QuizScreensManager.self) private var quizManager
    @State private var selectedAnswerIndex = 0
    
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
                
                // Picker for single selection
                Picker("Select an answer", selection: $selectedAnswerIndex) {
                    ForEach(0..<quizManager.currentQuestion.answers.count, id: \.self) { index in
                        Text(quizManager.currentQuestion.answers[index].text)
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
                    quizManager.selectAnswer(quizManager.currentQuestion.answers[selectedAnswerIndex])
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
        SingleQuestionSubview()
            .environment(QuizScreensManager())
    }
}
