//
//  MainTabView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

// *Main Tab View
/// Parent View of the entire app - the foundational structure that everything else gets built upon, and manages the navigation between the different sections.
/// Coordinates between header, content area, and bottom navigation bar
import SwiftUI

struct MainTabView: View {
    // *State Properties
    @State private var selectedTab = 0  // Tracks currently active tab (0=Today, 1=Calendar, 2=Assignments)
    
    // Get the current user from APIController
    private var currentUser: Student? {
        APIController.shared.currentUser
    }
    
    var body: some View {
        // We should only reach here if authenticated, but check just in case
        if currentUser != nil {
            ZStack {
                // *Global Background
                MountainlandColors.platinum.ignoresSafeArea()
                
                // *Main App Structure
                VStack(spacing: 0) {
                    
                    // *App Header
                    AppHeader(
                        title: "iOS Development",
                        subtitle: "Fall/Spring - 25/26"
                    )
                    
                    // *Content Area
                    Group {
                        switch selectedTab {
                        case 0:
                            // Today tab - shows daily lesson plan with calendar navigation capability
                            TodayView(onSwitchToCalendar: {
                                // Switch to Calendar tab when calendar icon is tapped
                                selectedTab = 1
                            })
                        case 1:
                            CalendarView()  // Calendar tab - shows monthly calendar view
                        case 2:
                            // UPDATED: Pass the current user to AssignmentView
                            // Use optional binding to safely unwrap
                            if let user = currentUser {
                                AssignmentView(currentUser: user)
                            } else {
                                // Fallback view - should not happen
                                Text("User data loading...")
                                    .foregroundColor(.secondary)
                            }
                        default:
                            // Fallback to Today view for invalid tab indices
                            TodayView(onSwitchToCalendar: {
                                selectedTab = 1
                            })
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)  // Expand to fill available space
                    
                    // *Bottom Navigation
                    BottomNavigationBar(
                        selectedTab: $selectedTab,  // Two-way binding for tab selection
                        tabs: BottomNavigationBar.mainTabs  // Predefined tab configuration
                    )
                }
            }
            .ignoresSafeArea(.keyboard)  // Prevents keyboard from resizing the main app layout
        } else {
            // This is a safety fallback - show loading while we try to restore
            VStack {
                ProgressView("Loading user data...")
                    .padding()
                
                Button("Try Again") {
                    APIController.shared.restoreSession()
                }
                .padding()
                .background(MountainlandColors.burgundy1)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
}

// MARK: - Preview
/// Xcode preview for design and layout testing
#Preview {
    // Set up a mock current user for preview
    // Create a temporary student in APIController for preview
    let mockStudent = Student.demoStudents[0]
    APIController.shared.currentUser = mockStudent
    
    return MainTabView()
}
