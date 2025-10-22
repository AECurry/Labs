//
//  QuizViewModel.swift
//  Personality Quiz Part 1
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

@Observable
class QuizViewModel {
    // MARK: - Properties
    let questionList: [Question] = QuestionBank.questions
    var currentQuestionIndex = 0
    var selectedAnswers: [Answer] = []
    
    // MARK: - Computed Properties
    var currentQuestion: Question {
        guard questionList.indices.contains(currentQuestionIndex) else {
            return Question(text: "Quiz Complete!", type: .single, answers: [])
        }
        return questionList[currentQuestionIndex]
    }
    
    var isLastQuestion: Bool {
        currentQuestionIndex == questionList.count - 1
    }
    
    var isFirstQuestion: Bool {
        currentQuestionIndex == 0
    }
    
    var progress: Double {
        Double(currentQuestionIndex) / Double(questionList.count)
    }
    
    // Check if current question is answered
    var isCurrentQuestionAnswered: Bool {
        guard selectedAnswers.indices.contains(currentQuestionIndex) else { return false }
        let currentAnswer = selectedAnswers[currentQuestionIndex]
        return !currentAnswer.text.isEmpty // The placeholder has empty text
    }
    
    // MARK: - Answer Selection Functions
    func selectAnswer(_ answer: Answer) {
        // Ensure we have an array slot for the current question
        while selectedAnswers.count <= currentQuestionIndex {
            selectedAnswers.append(Answer(text: "", points: [:])) // Placeholder
        }
        
        // Replace the answer at the current question index
        selectedAnswers[currentQuestionIndex] = answer
        
        print("Selected for Q\(currentQuestionIndex + 1): \(answer.text)")
        
        // Show points breakdown (for debugging)
        for (patronus, points) in answer.patronusPoints where points > 0 {
            print("  → \(patronus.emoji) \(patronus.rawValue): +\(points) points")
        }
    }
    
    // MARK: - Navigation Functions
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
    
    // MARK: - .onAppear Support Functions
    func onQuestionViewAppear() {
        print("🔮 Question \(currentQuestionIndex + 1) appeared: \(currentQuestion.text)")
        print("   Question type: \(currentQuestion.type)")
        print("   Number of answers: \(currentQuestion.answers.count)")
        print("   Already answered: \(isCurrentQuestionAnswered)")
        
        if isCurrentQuestionAnswered {
            let currentAnswer = selectedAnswers[currentQuestionIndex]
            print("   Pre-selected answer: '\(currentAnswer.text)'")
        }
    }
    
    func onResultsViewAppear() {
        print("🏆 Results view appeared - calculating final results...")
        let result = calculateResults()
        print("   Final result: \(result.components(separatedBy: "\n").first ?? "Unknown")")
    }
    
    func onContentViewAppear() {
        print("🚀 App started - Welcome to the Personality Quiz!")
        print("   Total questions: \(questionList.count)")
    }
    
    // MARK: - Results Calculation
    func calculateResults() -> String {
        var scores: [PatronusType: Int] = [:]
        
        // Calculate scores from all selected answers (skip placeholders)
        for answer in selectedAnswers where !answer.text.isEmpty {
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
    
    // MARK: - Reset Function
    func resetQuiz() {
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        print("🔄 Quiz reset - ready to start over")
    }
}
