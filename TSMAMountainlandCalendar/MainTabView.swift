//
//  MainTabView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

// MARK: - Main Tab View
/// Parent View of the entire app - the foundational structure that everything else gets built upon, and manages the navigation between the different sections.
/// Coordinates between header, content area, and bottom navigation bar
import SwiftUI

struct MainTabView: View {
    // MARK: - State Properties
    @State private var selectedTab = 0  // Tracks currently active tab (0=Today, 1=Calendar, 2=Assignments)
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // MARK: - Global Background
            /// Applies platinum color to entire screen behind all content
            MountainlandColors.platinum.ignoresSafeArea()
            
            // MARK: - Main App Structure
            /// Vertical stack containing header, content, and navigation
            VStack(spacing: 0) {
                // MARK: - App Header
                /// Displays course title and term information at top of screen
                AppHeader(
                    title: "iOS Development",
                    subtitle: "Fall/Spring - 25/26"
                )
                
                // MARK: - Content Area
                /// Dynamic content that changes based on selected tab
                Group {
                    switch selectedTab {
                    case 0:
                        TodayView()  // Today tab - shows daily lesson plan
                    case 1:
                        CalendarView()  // Calendar tab - shows monthly calendar view
                    case 2:
                        AssignmentAndRosterView()  // Assignments tab - shows assignments and roster
                    default:
                        TodayView()  // Fallback to Today view for invalid tab indices
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)  // Expand to fill available space
                
                // MARK: - Bottom Navigation
                /// Tab navigation bar for switching between main app sections
                BottomNavigationBar(
                    selectedTab: $selectedTab,  // Two-way binding for tab selection
                    tabs: BottomNavigationBar.mainTabs  // Predefined tab configuration
                )
            }
        }
        .ignoresSafeArea(.keyboard)  // Prevents keyboard from resizing the main app layout
    }
}
