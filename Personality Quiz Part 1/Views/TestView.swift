//
//  TestView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/12/25.
//

import SwiftUI

struct TestView: View {
    @Environment(QuizViewModel.self) private var quizManager
    
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
                    quizManager.resetQuiz()
                }
                .buttonStyle(.bordered)
                
             
                NavigationLink("Go to Single Question", destination: SingleQuestionSubview())
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
            .environment(QuizViewModel())
    }
}
