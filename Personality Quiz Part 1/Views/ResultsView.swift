//
//  ResultsView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct ResultsView: View {
    @Environment(QuizViewModel.self) private var viewModel // Updated name
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
                let result = viewModel.calculateResults() // Updated
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
                    // Reset quiz data using ViewModel function
                    viewModel.resetQuiz() 
                    
                    // Navigate all the way back to TitleView
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
