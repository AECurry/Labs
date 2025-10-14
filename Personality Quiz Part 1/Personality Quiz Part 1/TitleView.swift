//
//  TitleView.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/10/25.
//

import SwiftUI

struct TitleView: View {
    @Environment(QuizScreensManager.self) private var quizManager // ← ADD THIS LINE
    
    var body: some View {
        ZStack {
            // Use our reusable magical background
            MagicalBackground()
            
            VStack(spacing: 0) {
                
                // Top padding for the title section
                Spacer()
                    .frame(height: 60)
                
                // Title
                VStack(spacing: 10) {
                    Text("Discover Your")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("PATRONUS")
                        .font(.system(size: 60, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 0)
                }
                .padding(.bottom, 40)
                
                // Image container with magical border
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 300, height: 300)
                    
                    Image("patronus-title-image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 90)
                
                // Enhanced button with glow effect
                NavigationLink(destination: QuestionFlowView()) {
                    
                    HStack(spacing: 12) {
                        Text("Begin Quiz")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Image(systemName: "wand.and.stars")
                    }
                    .foregroundColor(.indigo)
                    .frame(width: 220, height: 60)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                // Subtle footer text
                Text("A Magical Personality Quiz")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 30)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Reset quiz when returning to title screen ← ADD THIS
            quizManager.currentQuestionIndex = 0
            quizManager.selectedAnswers.removeAll()
        }
    }
}

#Preview {
    NavigationStack {
        TitleView()
            .environment(QuizScreensManager()) // ← ADD ENVIRONMENT HERE
    }
}
