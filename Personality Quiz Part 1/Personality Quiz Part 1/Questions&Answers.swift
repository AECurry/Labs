//
//  Questions&Answers.swift
//  Personality Quiz Part 1
//
//  Created by [Your Name] on [Date]
//

import SwiftUI

// Question Structure
struct Question {
    var text: String
    var type: ResponseType
    var answers: [Answer]
}

// Question Types
enum ResponseType {
    case single, multiple, ranged, card
}

// Answer Structure with Point System
struct Answer {
    var text: String
    var patronusPoints: [PatronusType: Int]
    
    init(text: String, points: [PatronusType: Int]) {
        self.text = text
        self.patronusPoints = points
    }
}

// Patronus Types with Descriptions
enum PatronusType: String, CaseIterable {
    case stag = "Stag"
    case otter = "Otter"
    case wolf = "Wolf"
    case dolphin = "Dolphin"
    case swan = "Swan"
    case hare = "Hare"
    case fox = "Fox"
    case wildBoar = "Wild Boar"
    case granianWingedHorse = "Granian Winged Horse"
    
    var description: String {
        switch self {
        case .stag: return "The Protector - Noble and brave"
        case .otter: return "The Bright Friend - Intelligent and playful"
        case .wolf: return "The Pack Guardian - Loyal and protective"
        case .dolphin: return "The Joyful Guardian - Social and wise"
        case .swan: return "The Graceful Defender - Elegant and strong"
        case .hare: return "The Unique Visionary - Creative and intuitive"
        case .fox: return "The Clever Strategist - Adaptable and quick-witted"
        case .wildBoar: return "The Fearless Challenger - Brave and determined"
        case .granianWingedHorse: return "The Noble Specialist - Gifted and dedicated"
        }
    }
    
    var emoji: String {
        switch self {
        case .stag: return "🦌"
        case .otter: return "🦦"
        case .wolf: return "🐺"
        case .dolphin: return "🐬"
        case .swan: return "🦢"
        case .hare: return "🐇"
        case .fox: return "🦊"
        case .wildBoar: return "🐗"
        case .granianWingedHorse: return "🐎✨"
        }
    }
}

// Question Bank - All 10 Questions IN THIS SAME FILE
struct QuestionBank {
    static let questions: [Question] = [
        
        // Question 1: Card style
        Question(
            text: "What is your most valued trait in a close friend?",
            type: .card,
            answers: [
                Answer(text: "Unshakable loyalty, no matter what",
                       points: [.wolf: 2, .wildBoar: 1]),
                Answer(text: "A brilliant mind and clever wit",
                       points: [.otter: 2, .fox: 1]),
                Answer(text: "A kind and playful spirit that brings joy",
                       points: [.dolphin: 2, .otter: 1]),
                Answer(text: "The courage to be their unique, authentic self",
                       points: [.hare: 2, .granianWingedHorse: 1])
            ]
        ),
        
        // Question 2: Single choice
        Question(
            text: "When faced with a difficult problem, your first instinct is to:",
            type: .single,
            answers: [
                Answer(text: "Research and plan meticulously",
                       points: [.otter: 2, .fox: 1]),
                Answer(text: "Trust your gut and adapt as you go",
                       points: [.fox: 2, .hare: 1]),
                Answer(text: "Gather friends to tackle it together",
                       points: [.dolphin: 2, .wolf: 1]),
                Answer(text: "Charge ahead with determination",
                       points: [.wildBoar: 2, .stag: 1])
            ]
        ),
        
        // Question 3: Multiple choice
        Question(
            text: "Which activities do you find most inspiring?",
            type: .multiple,
            answers: [
                Answer(text: "Reading and learning new things",
                       points: [.otter: 2, .fox: 1]),
                Answer(text: "Creative arts and self-expression",
                       points: [.hare: 2, .granianWingedHorse: 1]),
                Answer(text: "Social gatherings with friends",
                       points: [.dolphin: 2, .wolf: 1]),
                Answer(text: "Physical challenges and sports",
                       points: [.stag: 2, .wildBoar: 1])
            ]
        ),
        
        // Question 4: Ranged
        Question(
            text: "How much do you enjoy social gatherings?",
            type: .ranged,
            answers: [
                Answer(text: "I prefer solitude",
                       points: [.hare: 2, .fox: 1]),
                Answer(text: "Small groups are best",
                       points: [.fox: 2, .swan: 1]),
                Answer(text: "I enjoy medium gatherings",
                       points: [.swan: 2, .dolphin: 1]),
                Answer(text: "The bigger the party, the better!",
                       points: [.dolphin: 2, .otter: 1])
            ]
        ),
        
        // Question 5: Card style
        Question(
            text: "What environment makes you feel most at peace?",
            type: .card,
            answers: [
                Answer(text: "A cozy library full of books",
                       points: [.otter: 2, .swan: 1]),
                Answer(text: "A vibrant social gathering",
                       points: [.dolphin: 2, .wolf: 1]),
                Answer(text: "The deep, quiet wilderness",
                       points: [.stag: 2, .hare: 1]),
                Answer(text: "Anywhere with wide open skies",
                       points: [.granianWingedHorse: 2, .fox: 1])
            ]
        ),
        
        // Question 6: Single choice
        Question(
            text: "What is your greatest strength in a team?",
            type: .single,
            answers: [
                Answer(text: "My ability to lead and protect",
                       points: [.stag: 2, .wolf: 1]),
                Answer(text: "My creativity and unique ideas",
                       points: [.hare: 2, .fox: 1]),
                Answer(text: "My dedication and hard work",
                       points: [.granianWingedHorse: 2, .wildBoar: 1]),
                Answer(text: "Keeping the team united and happy",
                       points: [.dolphin: 2, .swan: 1])
            ]
        ),
        
        // Question 7: Multiple choice
        Question(
            text: "What qualities do you admire most in others?",
            type: .multiple,
            answers: [
                Answer(text: "Bravery and courage",
                       points: [.wildBoar: 2, .stag: 1]),
                Answer(text: "Intelligence and wisdom",
                       points: [.otter: 2, .fox: 1]),
                Answer(text: "Loyalty and reliability",
                       points: [.wolf: 2, .swan: 1]),
                Answer(text: "Creativity and freedom",
                       points: [.granianWingedHorse: 2, .hare: 1])
            ]
        ),
        
        // Question 8: Ranged
        Question(
            text: "How do you feel about taking risks?",
            type: .ranged,
            answers: [
                Answer(text: "I avoid risks whenever possible",
                       points: [.swan: 2, .otter: 1]),
                Answer(text: "I'm cautious but will take calculated risks",
                       points: [.fox: 2, .stag: 1]),
                Answer(text: "I'm comfortable with reasonable risks",
                       points: [.stag: 2, .dolphin: 1]),
                Answer(text: "I thrive on adventure and risk",
                       points: [.wildBoar: 2, .granianWingedHorse: 1])
            ]
        ),
        
        // Question 9: Card style
        Question(
            text: "What does your perfect weekend look like?",
            type: .card,
            answers: [
                Answer(text: "Quiet time with a good book",
                       points: [.otter: 2, .swan: 1]),
                Answer(text: "An adventure with close friends",
                       points: [.wolf: 2, .dolphin: 1]),
                Answer(text: "A elegant evening with a loved one",
                       points: [.swan: 2, .stag: 1]),
                Answer(text: "Training for a personal goal",
                       points: [.granianWingedHorse: 2, .wildBoar: 1])
            ]
        ),
        
        // Question 10: Single choice (NO COMMA after this last one)
        Question(
            text: "What quality do you pride yourself on the most?",
            type: .single,
            answers: [
                Answer(text: "My courage and resilience",
                       points: [.wildBoar: 2, .stag: 1]),
                Answer(text: "My intelligence and knowledge",
                       points: [.otter: 2, .fox: 1]),
                Answer(text: "My loyalty and devotion",
                       points: [.wolf: 2, .swan: 1]),
                Answer(text: "My individuality and free spirit",
                       points: [.hare: 2, .granianWingedHorse: 1])
            ]
        ) // ← NO COMMA HERE (last element in array)
    ]
    
    // Helper to get points for an answer
    static func points(for answer: Answer, patronus: PatronusType) -> Int {
        return answer.patronusPoints[patronus] ?? 0
    }
}
