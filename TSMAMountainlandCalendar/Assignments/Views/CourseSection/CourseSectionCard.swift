//
//  CourseSectionCard.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Course Section Card
/// Displays a course module or section in a compact card format
/// Shows section number, title, date range, and optional navigation chevron
/// Supports both tappable and static display modes for flexible usage
/// This card is like a versatile building block that can be used anywhere you need to show course section information
struct CourseSectionCard: View {
    // MARK: - Properties
    let section: CourseSection          // The course section data to display
    let onTap: (() -> Void)?            // Optional closure called when card is tapped
    
    // MARK: - Body
    var body: some View {
        // MARK: - Card Content
        /// Reusable content that can be wrapped in a button or displayed statically
        let content = VStack(alignment: .leading, spacing: 8) {
            // MARK: - Horizontal Content Layout
            /// Arranges section number, text details, and chevron in a row
            HStack(alignment: .top) {
                // MARK: - Section Number
                /// Course section identifier in brand burgundy color
                /// Uses rounded font design for modern appearance
                Text(section.number)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundColor(MountainlandColors.burgundy1)
                
                // MARK: - Text Details Stack
                /// Vertical stack for section title and date range
                VStack(alignment: .leading, spacing: 4) {
                    // MARK: - Section Title
                    /// Main course section name in medium weight
                    Text(section.title)
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(MountainlandColors.smokeyBlack)
                        .multilineTextAlignment(.leading)  // Supports multi-line titles
                    
                    // MARK: - Date Range
                    /// When this course section runs throughout the semester
                    Text(section.dateRange)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(MountainlandColors.battleshipGray)
                }
                
                Spacer()  // Pushes chevron to trailing edge
                
                // MARK: - Navigation Chevron
                /// Indicates tappable navigation when onTap closure is provided
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(MountainlandColors.battleshipGray)
            }
        }
        .padding(.vertical, 12)    // Compact vertical padding
        .padding(.horizontal, 16)  // Standard side padding
        .background(MountainlandColors.white)  // Card background
        .cornerRadius(12)  // Rounded corners for card appearance
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)  // Subtle elevation shadow
        
        // MARK: - Conditional Wrapping
        /// Only makes card tappable if onTap closure is provided
        /// Allows reuse in both interactive and display-only contexts
        if let onTap = onTap {
            // MARK: - Tappable Card
            /// Wraps content in button for interactive navigation
            Button(action: onTap) {
                content
            }
            .buttonStyle(PlainButtonStyle())  // Removes default button styling
        } else {
            // MARK: - Static Card
            /// Displays content without interaction for read-only contexts
            content
        }
    }
}
