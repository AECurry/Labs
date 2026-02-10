//
//  AssignmentTypeCard.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

// *Assignment Type Card
/// Represents a "folder" containing multiple assignments (Labs, Challenges, Quizzes, etc.)
/// Shows category title, progress percentage, and completion status
/// Tappable card that navigates to assignments in this category
/// Features circular progress visualization with dynamic icon for complete/incomplete status
import SwiftUI

struct AssignmentTypeCard: View {
    
    // *State / Properties
    /// Assignment category data to display (title, progress, list of assignments)
    let assignmentType: AssignmentTypeSummary
    
    /// Closure called when card is tapped
    let onSelect: () -> Void
    
    // *Computed Properties
    /// Determines progress circle color based on completion
    /// Green if fully complete, burgundy if incomplete
    private var progressColor: Color {
        assignmentType.isComplete ? MountainlandColors.pigmentGreen : MountainlandColors.burgundy1
    }
    
    // *Body
    /// Main view for the assignment type card
    /// Displays circular progress indicator, title, stats, and navigation chevron
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 20) {
                
                // *Progress Circle
                /// Circular progress indicator visualizing completion percentage
                /// Checkmark icon when complete, bullet list when incomplete
                ZStack {
                    // Background circle showing total assignments
                    Circle()
                        .stroke(MountainlandColors.platinum, lineWidth: 4)
                    
                    // Foreground arc representing completed assignments
                    Circle()
                        .trim(from: 0, to: CGFloat(assignmentType.completionPercentage))
                        .stroke(progressColor, lineWidth: 4)
                        .rotationEffect(.degrees(-90)) // Start from top
                    
                    // Center icon
                    Image(systemName: assignmentType.isComplete ? "checkmark" : "list.bullet")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(progressColor)
                }
                .frame(width: 40, height: 40) // Fixed size for layout consistency
                
                // *Content Info
                /// Category title and completion stats
                VStack(alignment: .leading, spacing: 6) {
                    
                    // Category title
                    Text(assignmentType.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(MountainlandColors.smokeyBlack)
                    
                    // Completion statistics
                    Text("\(assignmentType.completedCount)/\(assignmentType.totalCount) completed")
                        .font(.body)
                        .foregroundColor(MountainlandColors.battleshipGray)
                }
                
                Spacer() // Push chevron to trailing edge
                
                // *Navigation Chevron
                /// Indicates card is tappable
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(MountainlandColors.battleshipGray)
            }
            .padding(.vertical, 88)    // Tall vertical padding for large tap target
            .padding(.horizontal, 24)  // Side padding for content spacing
            .background(MountainlandColors.adaptiveCard) // Card background
            .cornerRadius(16)          // Rounded card corners
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(MountainlandColors.platinum, lineWidth: 1) // Subtle border
            )
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}

// MARK: - Preview
/// Xcode preview showing three assignment category states:
/// 1. Incomplete (0/14 completed)
/// 2. Complete (28/28 completed)
/// 3. Partially complete (0/1 completed)
#Preview {
    VStack(spacing: 16) {
        
        // Incomplete Labs Preview
        AssignmentTypeCard(
            assignmentType: AssignmentTypeSummary(
                id: "labs",
                title: "Labs & Projects",
                completedCount: 0,
                totalCount: 14,
                assignments: []
            ),
            onSelect: {
                print("Labs selected")
            }
        )
        
        // Complete Challenges Preview
        AssignmentTypeCard(
            assignmentType: AssignmentTypeSummary(
                id: "challenges",
                title: "Code Challenges",
                completedCount: 28,
                totalCount: 28,
                assignments: []
            ),
            onSelect: {
                print("Challenges selected")
            }
        )
        
        // Single Item Quiz Preview
        AssignmentTypeCard(
            assignmentType: AssignmentTypeSummary(
                id: "vocab",
                title: "Vocab Quiz",
                completedCount: 0,
                totalCount: 1,
                assignments: []
            ),
            onSelect: {
                print("Vocab selected")
            }
        )
    }
    .padding()                           // Preview container padding
    .background(MountainlandColors.platinum) // Preview background matching app
}
