//
//  ResultsView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct ResultsView: View {
    @Environment(QuizScreensManager.self) private var quizManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            MagicalBackground()
            
            VStack(spacing: 30) {
                Text("Your Patronus Is...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Display the actual calculated results
                let result = quizManager.calculateResults()
                VStack(spacing: 15) {
                    Text(result)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Button("Take Quiz Again") {
                    // Reset quiz data
                    quizManager.currentQuestionIndex = 0
                    quizManager.selectedAnswers.removeAll()
                    
                    // Navigate all the way back to TitleView
                    // This will pop all views from the navigation stack
                    dismiss()
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.indigo)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 50)
                .shadow(color: .white.opacity(0.6), radius: 12, x: 0, y: 6)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ResultsView()
            .environment(QuizScreensManager())
    }
}
