//
//  BottomNavigationBar.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Navigation Item Model
/// Defines the structure for each tab in the bottom navigation bar
struct TabItem {
    let title: String    // Display name for the tab (e.g., "Today")
    let iconName: String // SF Symbol name for the tab icon
}

// MARK: - Bottom Navigation Bar
/// Custom bottom navigation bar with animated tab selection and gradient icons
/// Provides main app navigation between Today, Calendar, and Assignments sections
struct BottomNavigationBar: View {
    // MARK: - Properties
    @Binding var selectedTab: Int  // Tracks currently active tab (two-way binding)
    let tabs: [TabItem]            // Navigation items to display
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            // MARK: - Tab Buttons
            /// Creates equal-width buttons for each navigation item
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    // Spring animation when tab is tapped
                    withAnimation(.spring(response: 0.3, dampingFraction: 4)) {
                        selectedTab = index  // Update active tab
                    }
                } label: {
                    VStack(spacing: 2) {
                        // MARK: - Tab Icon with Gradient
                        /// Applies vertical gradient effect to SF Symbols
                        Image(systemName: tabs[index].iconName)
                            .symbolRenderingMode(.monochrome)  // Ensures gradient applies properly
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [
                                        Color(hex: "191612"),              // Dark brown/black at top
                                        MountainlandColors.burgundy1.opacity(0.8)  // Burgundy at bottom
                                    ],
                                    startPoint: .top,    // Gradient starts at top of icon
                                    endPoint: .bottom    // Gradient ends at bottom of icon
                                )
                            )
                            .font(.system(size: 24))     // Standard icon size
                            .frame(width: 40, height: 40) // Fixed icon container
                        
                        // MARK: - Tab Title
                        /// Display name below icon in solid color
                        Text(tabs[index].title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "191612"))  // Solid dark text
                    }
                    .frame(width: 104)  // Equal width for all tab buttons
                    .padding(.vertical, 16)  // Vertical padding for tap area
                }
                // MARK: - Active Tab Animation
                /// Bounce effect when tab is selected
                .scaleEffect(selectedTab == index ? 1.1 : 1.0)  // 10% scale increase for active tab
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
            }
        }
        .frame(maxWidth: .infinity)  // Expand to full width
        .background(MountainlandColors.platinum)  // Light gray background (#DDDDDC)
        .frame(height: 70)  // Fixed navigation bar height for consistent layout
    }
}

// MARK: - Predefined App Tabs
/// Standard tab configuration for the main app navigation
extension BottomNavigationBar {
    static let mainTabs = [
        TabItem(title: "Today", iconName: "house.fill"),              // Home icon for Today view
        TabItem(title: "Calendar", iconName: "calendar"),             // Calendar icon for month view
        TabItem(title: "Assignments", iconName: "list.bullet.clipboard.fill")  // Clipboard icon for assignments
    ]
}
