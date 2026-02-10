//
//  MainTabView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Main Tab View
/// Parent view of the entire app using Apple's native TabView
/// Provides type-safe navigation between app sections
/// Uses SwiftUI's built-in tab bar instead of custom implementation
struct MainTabView: View {
    // MARK: - State Properties
    
    /// Currently selected tab - type-safe using enum
    @State private var selectedTab: Tab = .today
    
    // MARK: - Computed Properties
    
    /// Retrieves the current authenticated user from APIController
    private var currentUser: Student? {
        APIController.shared.currentUser
    }
    
    // MARK: - Body
    
    var body: some View {
        // Verify user is authenticated before showing main app
        if let user = currentUser {
            
            // ✅ Apple's Native TabView - handles everything automatically
            TabView(selection: $selectedTab) {
                
                // MARK: - Today Tab
                TodayView(onSwitchToCalendar: {
                    selectedTab = .calendar  // Type-safe tab switching
                })
                .tabItem {
                    Label(Tab.today.title, systemImage: Tab.today.icon)
                }
                .tag(Tab.today)
                
                // MARK: - Calendar Tab
                CalendarView()
                    .tabItem {
                        Label(Tab.calendar.title, systemImage: Tab.calendar.icon)
                    }
                    .tag(Tab.calendar)
                
                // MARK: - Assignments Tab
                AssignmentView(currentUser: user)
                    .tabItem {
                        Label(Tab.assignments.title, systemImage: Tab.assignments.icon)
                    }
                    .tag(Tab.assignments)
            }
            .tint(MountainlandColors.burgundy1)  // Sets selected tab color
            .ignoresSafeArea(.keyboard)
            
        } else {
            // MARK: - Fallback State
            userLoadingView
        }
    }
    
    // MARK: - User Loading View
    
    /// Fallback view shown when user data is unavailable
    private var userLoadingView: some View {
        VStack(spacing: 20) {
            ProgressView("Loading user data...")
                .padding()
            
            Button(action: {
                APIController.shared.restoreSession()
            }) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(MountainlandColors.burgundy1)
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    // Set up mock user for preview
    let mockStudent = Student.demoStudents[0]
    APIController.shared.currentUser = mockStudent
    
    return MainTabView()
}
