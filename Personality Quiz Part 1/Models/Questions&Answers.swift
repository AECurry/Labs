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
        case .stag: return "The Protector - Noble, brave, and fiercely protective of loved ones"
        case .otter: return "The Bright Friend - Intelligent, playful, and clever problem-solver"
        case .wolf: return "The Pack Guardian - Loyal, protective, and values family above all"
        case .dolphin: return "The Joyful Guardian - Social, wise, and brings happiness to others"
        case .swan: return "The Graceful Defender - Elegant, strong-willed, and fiercely loyal"
        case .hare: return "The Unique Visionary - Creative, intuitive, and marches to their own drum"
        case .fox: return "The Clever Strategist - Adaptable, quick-witted, and resourceful"
        case .wildBoar: return "The Fearless Challenger - Brave, determined, and unstoppable"
        case .granianWingedHorse: return "The Noble Specialist - Gifted, dedicated, and exceptional"
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

// Question Bank - Improved for better distribution
// Question Bank - REBALANCED for better distribution
struct QuestionBank {
    static let questions: [Question] = [
        
        // Question 1: Core values - More specialized
        Question(
            text: "What is your most valued trait in a close friend?",
            type: .card,
            answers: [
                Answer(text: "Unshakable loyalty, no matter what",
                       points: [.wolf: 3, .stag: 2]), // Wolf specialty
                Answer(text: "A brilliant mind and clever wit",
                       points: [.otter: 3, .fox: 2]), // Otter specialty
                Answer(text: "A kind and playful spirit that brings joy",
                       points: [.dolphin: 3, .hare: 2]), // Dolphin specialty
                Answer(text: "The courage to be their unique, authentic self",
                       points: [.granianWingedHorse: 3, .wildBoar: 2]) // Specialized
            ]
        ),
        
        // Question 2: Problem solving - More distinct
        Question(
            text: "When faced with a difficult problem, your first instinct is to:",
            type: .single,
            answers: [
                Answer(text: "Research and plan meticulously",
                       points: [.otter: 3, .swan: 2]), // Thinkers
                Answer(text: "Trust your gut and adapt as you go",
                       points: [.fox: 3, .hare: 2]), // Adaptable
                Answer(text: "Gather friends to tackle it together",
                       points: [.dolphin: 3, .wolf: 2]), // Social
                Answer(text: "Charge ahead with determination",
                       points: [.wildBoar: 3, .stag: 2]) // Bold
            ]
        ),
        
        // Question 3: Activities - More specialized
        Question(
            text: "Which activities do you find most inspiring?",
            type: .multiple,
            answers: [
                Answer(text: "Reading and learning new things",
                       points: [.otter: 3, .swan: 1]), // Intellectual
                Answer(text: "Creative arts and self-expression",
                       points: [.hare: 3, .granianWingedHorse: 1]), // Creative
                Answer(text: "Social gatherings with friends",
                       points: [.dolphin: 3, .wolf: 1]), // Social
                Answer(text: "Physical challenges and sports",
                       points: [.stag: 3, .wildBoar: 1]) // Physical
            ]
        ),
        
        // Question 4: Social preferences - More extreme
        Question(
            text: "How much do you enjoy social gatherings?",
            type: .ranged,
            answers: [
                Answer(text: "I prefer solitude",
                       points: [.hare: 3, .fox: 2, .swan: 1]), // Solitary
                Answer(text: "Small groups are best",
                       points: [.swan: 2, .stag: 2, .otter: 1]), // Selective
                Answer(text: "I enjoy medium gatherings",
                       points: [.wolf: 2, .dolphin: 2, .fox: 1]), // Moderate
                Answer(text: "The bigger the party, the better!",
                       points: [.dolphin: 3, .wildBoar: 2, .granianWingedHorse: 1]) // Social
            ]
        ),
        
        // Question 5: Environment - More distinct
        Question(
            text: "What environment makes you feel most at peace?",
            type: .card,
            answers: [
                Answer(text: "A cozy library full of books",
                       points: [.otter: 3, .swan: 2]), // Intellectual
                Answer(text: "A vibrant social gathering",
                       points: [.dolphin: 3, .wolf: 2]), // Social
                Answer(text: "The deep, quiet wilderness",
                       points: [.stag: 3, .hare: 2, .fox: 1]), // Nature
                Answer(text: "Anywhere with wide open skies",
                       points: [.granianWingedHorse: 3, .wildBoar: 2]) // Freedom
            ]
        ),
        
        // Question 6: Team role - More specialized
        Question(
            text: "What is your greatest strength in a team?",
            type: .single,
            answers: [
                Answer(text: "My ability to lead and protect",
                       points: [.stag: 3, .wolf: 2]), // Leader
                Answer(text: "My creativity and unique ideas",
                       points: [.hare: 3, .granianWingedHorse: 2]), // Creative
                Answer(text: "My dedication and hard work",
                       points: [.wildBoar: 3, .granianWingedHorse: 2]), // Worker
                Answer(text: "Keeping the team united and happy",
                       points: [.dolphin: 3, .swan: 2]) // Unifier
            ]
        ),
        
        // Question 7: Admired qualities - More focused
        Question(
            text: "What qualities do you admire most in others?",
            type: .multiple,
            answers: [
                Answer(text: "Bravery and courage",
                       points: [.wildBoar: 3, .stag: 2]), // Brave
                Answer(text: "Intelligence and wisdom",
                       points: [.otter: 3, .fox: 2]), // Smart
                Answer(text: "Loyalty and reliability",
                       points: [.wolf: 3, .swan: 2]), // Loyal
                Answer(text: "Creativity and freedom",
                       points: [.hare: 3, .granianWingedHorse: 2]) // Free-spirited
            ]
        ),
        
        // Question 8: Risk tolerance - More extreme
        Question(
            text: "How do you feel about taking risks?",
            type: .ranged,
            answers: [
                Answer(text: "I avoid risks whenever possible",
                       points: [.swan: 3, .otter: 2]), // Cautious
                Answer(text: "I'm cautious but will take calculated risks",
                       points: [.fox: 3, .wolf: 1]), // Calculated
                Answer(text: "I'm comfortable with reasonable risks",
                       points: [.dolphin: 2, .stag: 2, .hare: 1]), // Balanced
                Answer(text: "I thrive on adventure and risk",
                       points: [.wildBoar: 3, .granianWingedHorse: 2]) // Adventurous
            ]
        ),
        
        // Question 9: Weekend preferences - More distinct
        Question(
            text: "What does your perfect weekend look like?",
            type: .card,
            answers: [
                Answer(text: "Quiet time with a good book",
                       points: [.otter: 3, .hare: 2]), // Quiet
                Answer(text: "An adventure with close friends",
                       points: [.wolf: 3, .dolphin: 2]), // Social adventure
                Answer(text: "An elegant evening with a loved one",
                       points: [.swan: 3, .stag: 2]), // Refined
                Answer(text: "Training for a personal goal",
                       points: [.granianWingedHorse: 3, .wildBoar: 2]) // Ambitious
            ]
        ),
        
        // Question 10: Proudest quality - More specialized
        Question(
            text: "What quality do you pride yourself on the most?",
            type: .single,
            answers: [
                Answer(text: "My courage and resilience",
                       points: [.wildBoar: 3, .stag: 2]), // Brave
                Answer(text: "My intelligence and knowledge",
                       points: [.otter: 3, .fox: 2]), // Intelligent
                Answer(text: "My loyalty and devotion",
                       points: [.wolf: 3, .swan: 2]), // Loyal
                Answer(text: "My individuality and free spirit",
                       points: [.hare: 3, .granianWingedHorse: 2]) // Unique
            ]
        )
    ]
}
