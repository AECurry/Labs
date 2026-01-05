//
//  GamingProfileSection.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

struct GamingProfileSection: View {
    @Binding var skillLevel: SkillLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Skill Level")
            
            // Add spacing between title and skill level
            VStack(spacing: 24) {
                SkillLevelPicker(selectedLevel: $skillLevel)
            }
        }
        .sectionStyle()
    }
}

// MARK: - Skill Level Picker Component

struct SkillLevelPicker: View {
    @Binding var selectedLevel: SkillLevel
    
    private let skillRows: [[SkillLevel]] = [
           [.beginner, .intermediate],
           [.advanced, .pro]
       ]
    
    var body: some View {
        
        // Grid layout - 2 rows x 2 columns
                    VStack(spacing: 12) {
                        ForEach(0..<skillRows.count, id: \.self) { rowIndex in
                            HStack(spacing: 12) {
                                ForEach(skillRows[rowIndex], id: \.self) { level in
                                    SkillLevelButton(
                                        level: level,
                                        isSelected: selectedLevel == level,
                                        action: { selectedLevel = level }
                                    )
                                }
                            }
                        }
                    }
                }
            }

        // MARK: - Individual Skill Level Button Component
        struct SkillLevelButton: View {
            let level: SkillLevel
            let isSelected: Bool
            let action: () -> Void
            
            var body: some View {
                Button(action: action) {
                    VStack(spacing: 8) {
                        // Icon at the top
                        Image(systemName: level.icon)
                            .font(.title2)
                            .foregroundColor(isSelected ? level.color : .fnGray1)
                        
                        // Skill level name
                        Text(level.rawValue)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(isSelected ? .fnWhite : .fnGray1)
                            .fixedSize(horizontal: false, vertical: true) // Allow text wrapping
                            .lineLimit(2) // Allow 2 lines if needed
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .background(
                        isSelected ?
                        level.color.opacity(0.3) : Color.fnGray2
                    )
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? level.color : Color.clear, lineWidth: 2)
                    )
                }
            }
        }

        #Preview {
            ZStack {
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                GamingProfileSection(
                    skillLevel: .constant(.intermediate)
                )
                .padding()
            }
        }
