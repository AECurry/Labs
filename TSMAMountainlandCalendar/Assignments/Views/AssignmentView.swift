//
//  AssignmentView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Assignment View
/// Main assignments screen that displays all assignments from the API
/// Shows assignments organized by status (overdue, upcoming, completed)
/// Provides a clean, intuitive interface for assignment management
/// Serves as primary assignments interface in bottom navigation tab
struct AssignmentView: View {
    // MARK: - Properties
    
    /// Current user for personalized display and authentication context
    /// Provides user-specific assignment data and progress tracking
    let currentUser: Student
    
    /// ViewModel instance managing assignment data, loading states, and API interactions
    /// Uses @State wrapper for @Observable ViewModel with reactive UI updates
    /// Handles data transformation, error management, and assignment progress tracking
    @State private var viewModel = AssignmentsViewModel()
    
    // MARK: - Body
    /// Main view hierarchy defining the assignments screen layout
    /// Organizes content with app header and dynamic content area
    /// Implements reactive UI updates based on ViewModel state changes
    var body: some View {
        // REMOVED: NavigationStack wrapper since MainTabView already handles navigation
        VStack(spacing: 0) {
            // MARK: - Content Area (NO HEADER - MainTabView already has one)
            /// Dynamically shows loading, error, or assignment list content
            /// Reacts to ViewModel state changes for appropriate UI presentation
            contentView
        }
        .background(MountainlandColors.platinum.ignoresSafeArea())
        .task {
            // Load assignments when view appears
            /// Triggers asynchronous API call to fetch all assignments for current user
            /// Manages loading states and error handling automatically
            await viewModel.loadAssignments()
        }
    }
    
    // MARK: - Content View
    /// Dynamically switches between loading, error, and assignment list states
    /// Uses @ViewBuilder for conditional view composition based on ViewModel state
    /// Follows clean view composition patterns for maintainable UI code
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else {
            AssignmentListView(
                currentUser: currentUser,
                assignments: viewModel.assignments
            )
            .padding(.top, 8) // Add some top padding to prevent content from being too close to header
        }
    }
    
    // MARK: - Loading State
    /// Shows progress indicator while assignments are loading from API
    /// Provides visual feedback during asynchronous data retrieval operations
    /// Maintains consistent loading presentation across the application
    private var loadingView: some View {
        ProgressView("Loading assignments...")
            .padding()
            .frame(maxHeight: .infinity)
    }
    
    // MARK: - Error State
    /// Displays error message and retry button when assignment loading fails
    /// Helps users recover from network or server issues with clear feedback
    /// Provides actionable retry option for improved user experience
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            // Error title for clear problem identification
            Text("Error Loading Assignments")
                .font(.headline)
                .foregroundColor(MountainlandColors.smokeyBlack)
            
            // Detailed error message for user information
            Text(error)
                .font(.body)
                .foregroundColor(MountainlandColors.battleshipGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            // Retry button for error recovery
            Button("Retry") {
                Task { await viewModel.loadAssignments() }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(MountainlandColors.burgundy1)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MountainlandColors.platinum)
    }
}

// MARK: - Preview
/// Xcode preview for design and layout testing during development
/// Shows the assignment view with sample student data and interaction simulation
#Preview {
    AssignmentView(currentUser: Student.demoStudents[0])
}
