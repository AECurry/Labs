//
//  CardStackView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/8/25.
//

import SwiftUI

// MARK: - Card Stack View
/// Creates a visually stacked card interface where cards overlap with decreasing offsets
/// Provides a compact, layered display of daily content items
struct CardStackView: View {
    // MARK: - Properties
    let dailyContent: DailyContent  // Container for daily lesson entries
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Stacked Card Layout
            /// Iterates through content entries with index for positioning
            ForEach(Array(dailyContent.entries.enumerated()), id: \.offset) { index, entry in
                // Find the corresponding category for this entry
                if let category = ContentCategory.defaultCategories.first(where: { $0.id == entry.categoryId }) {
                    CardView(
                        emoji: emojiForCategory(category),
                        title: category.title,
                        content: entry.content,
                        isTopCard: index == 0  // Only first card has rounded top corners
                    )
                    .offset(y: CGFloat(index * 16))  // Each card is offset 16pt below previous
                    .zIndex(Double(dailyContent.entries.count - index))  // Lower cards have higher z-index
                }
            }
        }
    }
    
    // MARK: - Emoji Mapping
    /// Maps content category IDs to appropriate emoji icons
    private func emojiForCategory(_ category: ContentCategory) -> String {
        // Map your category IDs to emojis
        switch category.id {
        case "word_of_day": return "📚"     // Book emoji for word of the day
        case "instructor": return "👨‍🏫"     // Teacher emoji for instructor
        case "code_challenge": return "💻"  // Computer emoji for code challenges
        case "topic_outline": return "📋"   // Clipboard emoji for lesson outline
        case "labs_due": return "🔬"        // Microscope emoji for lab assignments
        case "reading": return "📖"         // Book emoji for reading assignments
        case "review_topic": return "🔄"    // Refresh emoji for review topics
        default: return "📝"                // Memo emoji as fallback
        }
    }
}
