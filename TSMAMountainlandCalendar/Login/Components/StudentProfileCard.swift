//
//  StudentProfileCard.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/11/25.
//

import SwiftUI

// MARK: - Student Profile Card
/// Custom-designed student card with layered visual elements
/// Features profile picture, name, gradient bar, and navigation indicator
/// Uses precise positioning for pixel-perfect design implementation to ensure consistent appearance across devices

struct StudentProfileCard: View {
    // MARK: - Properties
    let student: Student  // The student data to display in the card
    
    // MARK: - Card Dimensions
    /// Precisely defined measurements for consistent card appearance
    /// Uses fixed sizes for controlled, predictable layout
    private let cardWidth: CGFloat = 400        // Total card width
    private let cardHeight: CGFloat = 56        // Total card height
    private let whiteCardHeight: CGFloat = 48   // Height of white content area
    private let gradientHeight: CGFloat = 16    // Height of colored gradient bar
    private let profileSize: CGFloat = 72       // Diameter of profile circle
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - White Content Card
            /// Primary white rectangle serving as card background
            /// Positioned at top portion of total card height
            Rectangle()
                .fill(MountainlandColors.white)
                .frame(width: cardWidth, height: whiteCardHeight)
                .position(x: 250, y: 32 / 2)  // Centered horizontally, aligned to top
            
            // MARK: - Gradient Bar
            /// Brand-colored gradient strip at bottom of white card
            /// Adds visual interest and brand identity with shadow for depth
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [MountainlandColors.burgundy1, MountainlandColors.burgundy2],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: cardWidth, height: gradientHeight)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 3)  // Subtle elevation shadow
                .position(x: 250, y: 88 / 2)  // Positioned below white card
                
            
            // MARK: - Student Name
            /// Student's full name displayed in prominent typography
            /// Positioned to the right of profile picture
            Text(student.name)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(MountainlandColors.smokeyBlack)
                .position(x: 190, y: whiteCardHeight / 3)  // Left-aligned text position
            
            // MARK: - Navigation Chevron
            /// Indicates card is tappable and leads to another screen
            /// Positioned at trailing edge for clear navigation affordance
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(MountainlandColors.battleshipGray)
                .position(x: 360, y: whiteCardHeight / 3)  // Right-edge positioning
            
            // MARK: - Profile Picture Circle
            /// Circular avatar showing student initials in brand colors
            /// Overlaps both white card and gradient bar for visual integration
            ZStack {
                Circle()
                    .fill(MountainlandColors.burgundy2)  // Brand color background
                    .frame(width: profileSize, height: profileSize)
                
                Text(student.initials)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .position(x: 52, y: whiteCardHeight / 2) // Fixed position: 16px from left + centered vertically
        }
        .frame(width: cardWidth, height: cardHeight)  // Fixed container size
        .padding(.vertical, 24) // THIS ADDS SPACE BETWEEN CARDS - Vertical spacing for list separation
    }
}
