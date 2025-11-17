//
//  AppHeader.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

/// Reusable app header component with Mountainland branding
/// Used across all main views for consistent app identity
struct AppHeader: View {
    // MARK: - Properties
    let title: String       // Main header title (e.g., "iOS Development")
    let subtitle: String    // Secondary subtitle (e.g., "Fall/Spring - 25/26")
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // Horizontal container for logo and text
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
                
                // Right spacer - balanced push from right edge
                  Spacer()
                      .frame(minWidth: 40, maxWidth: 40)
              }
            
            // MARK: - Container Padding
            /// Horizontal padding for side margins
            /// Vertical padding for top/bottom spacing
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

