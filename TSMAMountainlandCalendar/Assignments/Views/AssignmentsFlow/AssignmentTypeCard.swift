//
//  AssignmentTypeCard.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Assignment Type Card
/// AssignmentTypeCard = Like a "folder" that contains many assignments
/// AssignmentRowView = a file that goes  inside this folder
/// Displays an assignment category with progress visualization and completion status
/// Features a circular progress indicator and tappable card design for navigation
struct AssignmentTypeCard: View {
    // MARK: - Properties
    let assignmentType: AssignmentTypeSummary  // Assignment category data to display
    let onSelect: () -> Void                   // Closure called when card is tapped
    
    // MARK: - Computed Properties
    /// Determines progress circle color based on completion status
    /// Green for fully complete categories, burgundy for incomplete
    private var progressColor: Color {
        assignmentType.isComplete ? MountainlandColors.pigmentGreen : MountainlandColors.burgundy1
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 20) {
                // MARK: - Progress Circle Visualization
                /// Circular progress indicator showing completion percentage
                /// Shows checkmark icon when complete, list icon when incomplete
                ZStack {
                    // MARK: - Background Circle
                    /// Static gray circle showing total possible progress
                    Circle()
                        .stroke(MountainlandColors.platinum, lineWidth: 4)
                    
                    // MARK: - Progress Arc
                    /// Colored arc representing completed percentage
                    /// Rotated -90 degrees to start from top position
                    Circle()
                        .trim(from: 0, to: CGFloat(assignmentType.completionPercentage))
                        .stroke(progressColor, lineWidth: 4)
                        .rotationEffect(.degrees(-90))
                    
                    // MARK: - Center Icon
                    /// Checkmark for complete categories, bullet list for incomplete
                    Image(systemName: assignmentType.isComplete ? "checkmark" : "list.bullet")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(progressColor)
                }
                .frame(width: 40, height: 40)  // Fixed size for consistent layout
                
                // MARK: - Content Information
                /// Text content showing category title and completion statistics
                VStack(alignment: .leading, spacing: 6) {
                    // MARK: - Category Title
                    /// Assignment type name (e.g., "Labs & Projects")
                    Text(assignmentType.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(MountainlandColors.smokeyBlack)
                    
                    // MARK: - Completion Statistics
                    /// Count of completed assignments vs total assignments
                    Text("\(assignmentType.completedCount)/\(assignmentType.totalCount) completed")
                        .font(.body)
                        .foregroundColor(MountainlandColors.battleshipGray)
                }
                
                Spacer()  // Pushes chevron to trailing edge
                
                // MARK: - Navigation Chevron
                /// Indicates card is tappable and leads to another screen
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(MountainlandColors.battleshipGray)
            }
            .padding(.vertical, 88)  // Tall vertical padding for large tap target
            .padding(.horizontal, 24)  // Side padding for content spacing
            .background(MountainlandColors.adaptiveCard)  // Card background color
            .cornerRadius(16)  // Rounded card corners
            .overlay(
                // MARK: - Card Border
                /// Subtle border around card for visual definition
                RoundedRectangle(cornerRadius: 16)
                    .stroke(MountainlandColors.platinum, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())  // Removes default button styling
    }
}

// MARK: - Preview
/// Xcode preview showing three assignment category states:
/// - Incomplete (0/14 completed)
/// - Complete (28/28 completed)
/// - Partially complete (0/1 completed)
#Preview {
    VStack(spacing: 16) {
        // MARK: - Incomplete Labs Preview
        /// Shows burgundy progress circle with list icon
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
        
        // MARK: - Complete Challenges Preview
        /// Shows green progress circle with checkmark icon
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
        
        // MARK: - Single Item Quiz Preview
        /// Shows empty progress circle for 0/1 completion
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
    .padding()  // Preview container padding
    .background(MountainlandColors.platinum)  // Preview background matching app
}
