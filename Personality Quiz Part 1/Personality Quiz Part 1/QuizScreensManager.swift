//
//  QuizScreensManager.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/11/25.
//

import SwiftUI

@Observable
class QuizScreensManager {
    // Updated to use our QuestionBank
    let questionList: [Question] = QuestionBank.questions
    
    var currentQuestionIndex = 0
    var selectedAnswers: [Answer] = []
    
    // Computed property to get the current question
    var currentQuestion: Question {
        guard questionList.indices.contains(currentQuestionIndex) else {
            return Question(text: "Quiz Complete!", type: .single, answers: [])
        }
        return questionList[currentQuestionIndex]
    }
    
    // Check if we've reached the end of the quiz
    var isLastQuestion: Bool {
        currentQuestionIndex == questionList.count - 1
    }
    
    // Check if we're at the first question
    var isFirstQuestion: Bool {
        currentQuestionIndex == 0
    }
    
    // FIXED: Replace answer for current question instead of appending
    func selectAnswer(_ answer: Answer) {
        // Ensure we have an array slot for the current question
        while selectedAnswers.count <= currentQuestionIndex {
            selectedAnswers.append(Answer(text: "", points: [:])) // Placeholder
        }
        
        // Replace the answer at the current question index
        selectedAnswers[currentQuestionIndex] = answer
        
        print("Selected for Q\(currentQuestionIndex + 1): \(answer.text)")
        print("Total selected answers: \(selectedAnswers.count)")
        
        // Show points breakdown (for debugging)
        for (patronus, points) in answer.patronusPoints where points > 0 {
            print("  → \(patronus.emoji) \(patronus.rawValue): +\(points) points")
        }
    }
    
    // Navigation functions
    func goToNextQuestion() {
        if currentQuestionIndex < questionList.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    func goToPreviousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    // Step 11: Function to calculate final results
    func calculateResults() -> String {
        // We'll implement the patronus scoring logic here
        var scores: [PatronusType: Int] = [:]
        
        // Calculate scores from all selected answers
        for answer in selectedAnswers {
            for (patronus, points) in answer.patronusPoints {
                scores[patronus, default: 0] += points
            }
        }
        
        // Debug: Print all scores
        print("Final scores:")
        for (patronus, score) in scores.sorted(by: { $0.value > $1.value }) {
            print("  \(patronus.emoji) \(patronus.rawValue): \(score) points")
        }
        
        // Find the highest scoring patronus
        if let winningPatronus = scores.max(by: { $0.value < $1.value })?.key {
            return "\(winningPatronus.emoji) \(winningPatronus.rawValue)\n\(winningPatronus.description)"
        }
        
        return "Unable to calculate your Patronus. Please try again."
    }
}

#Preview {
    // Preview for testing our manager
    VStack {
        Text("QuizScreensManager Preview")
            .font(.title)
        
        Text("This manages which of the 4 screen types to show")
            .padding()
    }
}
