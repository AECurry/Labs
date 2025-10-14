//
//  CardQuestionSubview.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct CardQuestionSubview: View {
    @Environment(QuizScreensManager.self) private var quizManager
    @State private var selectedCardIndex: Int? = nil
    
    var body: some View {
        ZStack {
            MagicalBackground()
            
            VStack(spacing: 0) {
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
                    .padding(.top, 20)
                
                // Grid of 4 Tall Rectangle Cards
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 20),
                        GridItem(.flexible(), spacing: 20)
                    ],
                    spacing: 20
                ) {
                    ForEach(0..<quizManager.currentQuestion.answers.count, id: \.self) { index in
                        CardView(
                            answer: quizManager.currentQuestion.answers[index],
                            isSelected: selectedCardIndex == index,
                            onTap: {
                                selectedCardIndex = index
                                quizManager.selectAnswer(quizManager.currentQuestion.answers[index])
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
                Spacer()
                
                // Bottom Navigation Buttons
                NavigationButtons()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

// Separate CardView for cleaner code
struct CardView: View {
    let answer: Answer
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(
                LinearGradient(
                    colors: [.white.opacity(0.3), .white.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
              )
              .overlay(
                  RoundedRectangle(cornerRadius: 15)
                      .stroke(isSelected ? Color.white : Color.white.opacity(0.4),
                             lineWidth: isSelected ? 6 : 1)
              )
              .frame(height: 200)
              .overlay(
                  Text(answer.text)
                      .foregroundColor(.white)
                      .fontWeight(.medium)
                      .multilineTextAlignment(.center)
                      .padding(15)
              )
        // Extremely subtle glow - barely noticeable
                   .shadow(color: isSelected ? .white.opacity(0.2) : .black.opacity(0.1),
                          radius: isSelected ? 3 : 2,  // Minimal radius
                          x: 0, y: 0)
                   .onTapGesture(perform: onTap)
           }
       }

#Preview {
    NavigationStack {
        CardQuestionSubview()
            .environment(QuizScreensManager())
    }
}
