//
//  TestView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/12/25.
//

import SwiftUI

struct TestView: View {
    @Environment(QuizScreensManager.self) private var quizManager
    
    var body: some View {
        ZStack {
            MagicalBackground()
            
            VStack(spacing: 20) {
                Text("TEST VIEW")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Question Index: \(quizManager.currentQuestionIndex)")
                    .foregroundColor(.white)
                
                Text("Question Text: \(quizManager.currentQuestion.text)")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Answers Count: \(quizManager.currentQuestion.answers.count)")
                    .foregroundColor(.white)
                
                Button("Go to Next Question") {
                    quizManager.goToNextQuestion()
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset Quiz") {
                    quizManager.currentQuestionIndex = 0
                    quizManager.selectedAnswers.removeAll()
                }
                .buttonStyle(.bordered)
                
                // ADD THIS - Navigate to actual quiz
                NavigationLink("Go to Actual Quiz", destination: QuestionFlowView())
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        TestView()
            .environment(QuizScreensManager())
    }
}
