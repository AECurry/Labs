//
//  ScoringRulesSectio.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

// MARK: - Scoring Rules Enums
enum SortOrder: String, CaseIterable {
    case highestToLowest = "Highest → Lowest"
    case lowestToHighest = "Lowest → Highest"
    
    var icon: String {
        switch self {
        case .highestToLowest: return "arrow.down"
        case .lowestToHighest: return "arrow.up"
        }
    }
    
    var description: String {
        switch self {
        case .highestToLowest: return "Best players at top"
        case .lowestToHighest: return "Best players at bottom"
        }
    }
}

enum WinCondition: String, CaseIterable {
    case highestScore = "Highest team score"
    case lowestScore = "Lowest team score"
    
    var icon: String {
        switch self {
        case .highestScore: return "trophy.fill"
        case .lowestScore: return "flag.checkered"
        }
    }
    
    var description: String {
        switch self {
        case .highestScore: return "Team with most points wins"
        case .lowestScore: return "Team with least points wins"
        }
    }
}

// MARK: - Scoring Rules Section Component
struct ScoringRulesSection: View {
    @Binding var sortOrder: SortOrder
    @Binding var winCondition: WinCondition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Scoring Rules")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            VStack(spacing: 16) {
                // Player Sort Order
                VStack(alignment: .leading, spacing: 12) {
                    Text("Players sorted:")
                        .font(.subheadline)
                        .foregroundColor(.fnGray1)
                    
                    HStack(spacing: 12) {
                        ForEach(SortOrder.allCases, id: \.self) { order in
                            ScoringRuleButton(
                                isSelected: sortOrder == order,
                                icon: order.icon,
                                title: order.rawValue,
                                description: order.description
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    sortOrder = order
                                }
                            }
                        }
                    }
                }
                
                // Divider
                Rectangle()
                    .fill(Color.fnGray2.opacity(0.3))
                    .frame(height: 1)
                    .padding(.vertical, 4)
                
                // Win Condition
                VStack(alignment: .leading, spacing: 12) {
                    Text("Winner:")
                        .font(.subheadline)
                        .foregroundColor(.fnGray1)
                    
                    HStack(spacing: 12) {
                        ForEach(WinCondition.allCases, id: \.self) { condition in
                            ScoringRuleButton(
                                isSelected: winCondition == condition,
                                icon: condition.icon,
                                title: condition.rawValue,
                                description: condition.description
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    winCondition = condition
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.fnBlack.opacity(0.3))
        .cornerRadius(12)
    }
}

// MARK: - Scoring Rule Button Component
struct ScoringRuleButton: View {
    let isSelected: Bool
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Icon
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .fnWhite : .fnGray1)
                
                // Title
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .fnWhite : .fnGray1)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Description
                Text(description)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .fnGray1 : .fnGray2)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.fnBlue.opacity(0.3) : Color.fnGray2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.fnBlue : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        ScrollView {
            VStack(spacing: 20) {
                ScoringRulesSection(
                    sortOrder: .constant(.highestToLowest),
                    winCondition: .constant(.highestScore)
                )
                
                ScoringRulesSection(
                    sortOrder: .constant(.lowestToHighest),
                    winCondition: .constant(.lowestScore)
                )
            }
            .padding()
        }
    }
}
