//
//  AppHeader.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

/// Reusable app header component with Mountainland branding
/// Used across all main views for consistent app identity
/// Displays logo, course title, and semester info on branded background
/// Content aligned to match card positioning for visual consistency
struct AppHeader: View {
    // MARK: - Properties
    let title: String       // Main header title (e.g., "iOS Development")
    let subtitle: String    // Secondary subtitle (e.g., "Fall/Spring - 25/26")
    
    // MARK: - Body
    var body: some View {
        // MARK: - Full-Width Background Container
        /// Background extends edge-to-edge regardless of device size
        VStack(spacing: 0) {
            // MARK: - Header Content Container
            /// Horizontal container for logo and text
            /// ✅ FIXED: Aligned with cards using matching horizontal padding
            HStack(alignment: .center, spacing: 16) {
                
                // MARK: - Mountainland Institution Logo
                /// Displays the Mountainland Technical College logo with fixed height
                Image("MountainlandLogo1")
                    .resizable()                    // Allows size adjustment
                    .scaledToFit()                  // Maintains aspect ratio
                    .frame(height: 56)              // Fixed height, auto width
                
                // MARK: - Text Content Stack
                /// Vertical stack for title and subtitle
                /// Aligned to leading edge for clean left alignment
                VStack(alignment: .leading, spacing: 8) {
                    // Primary course/program title
                    Text(title)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(MountainlandColors.smokeyBlack)
                    
                    // Secondary semester information
                    Text(subtitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(MountainlandColors.smokeyBlack)
                }
                
                // Right spacer - pushes content to fill width
                Spacer()
            }
            // MARK: - Content Padding
            /// ✅ FIXED: Matches card horizontal padding (32pt) for perfect alignment
            /// Cards use 16pt padding, but they're inside a container with 16pt padding
            /// So header needs 32pt total to align with card content
            .padding(.horizontal, 32)  // ✅ CHANGED from 16 to 32
            .padding(.vertical, 16)
        }
        // MARK: - Background Color
        /// Edge-to-edge light gray background
        /// Extends to full width of screen regardless of device size
        .frame(maxWidth: .infinity)  // Expand to full width
        .background(MountainlandColors.platinum)  // Light gray background
    }
}

// MARK: - Preview
/// Xcode preview for testing header appearance
#Preview {
    VStack(spacing: 0) {
        AppHeader(
            title: "iOS Development",
            subtitle: "Fall/Spring - 25/26"
        )
        
        // Sample content to verify alignment
        VStack(spacing: 16) {
            // Sample card for alignment testing
            VStack(alignment: .leading, spacing: 8) {
                Text("Sample Card")
                    .font(.headline)
                Text("This should align with the header text above")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
        }
        .padding(.top, 16)
        
        Spacer()
            .background(MountainlandColors.smokeWhite)
    }
}
