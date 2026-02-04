//
//  CourseSectionView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Course Section View
/// Simple view that shows course sections as cards
/// Each card navigates to the assignment list for that section
/// Provides navigation interface for accessing assignments by course section
/// Uses API-based ViewModel for real assignment data retrieval
struct CourseSectionView: View {
    // MARK: - Properties
    
    /// Sample course section data for navigation interface
    /// Provides structured access to different course modules and topics
    @State private var sections = CourseSection.demoData
    
    /// ViewModel instance managing assignment data loading and state
    /// Uses @State wrapper for @Observable ViewModel with reactive updates
    /// Fetches real assignment data from API for display in assignment lists
    @State private var viewModel = AssignmentsViewModel()
    
    /// Environment value for programmatic view dismissal
    /// Enables back navigation without relying on navigation stack alone
    @Environment(\.dismiss) private var dismiss
    
    /// Current authenticated student for personalized display
    /// Provides user context for assignment filtering and display preferences
    let currentUser: Student
    
    // MARK: - Body
    /// Main view hierarchy defining course section navigation interface
    /// Organizes content with custom header, title, and scrollable section cards
    /// Implements navigation to assignment lists with filtered content
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header with Profile and Back Button
                /// Custom navigation bar with back functionality and user profile
                /// Provides consistent navigation pattern across the application
                HStack {
                    // Back button for returning to previous screen
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    // User Profile Circle with student initials
                    /// Visual representation of current user in navigation header
                    /// Uses brand colors for consistent visual identity
                    ZStack {
                        Circle()
                            .fill(MountainlandColors.burgundy2)
                            .frame(width: 40, height: 40)
                        
                        Text(currentUser.initials)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                // MARK: - Screen Title
                /// Clear page title indicating content purpose and scope
                /// Uses prominent typography for easy identification
                Text("Course Assignments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 40)
                
                // MARK: - Course Sections Content
                /// Scrollable list of course section cards with navigation links
                /// Each card represents a different course module or topic area
                /// Tapping any card navigates to filtered assignment list for that section
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(sections) { section in
                            NavigationLink {
                                // Navigation destination: Assignment list filtered by section
                                /// Passes all assignments since section-based filtering isn't implemented
                                /// Future enhancement: Implement section-specific assignment filtering
                                AssignmentListView(
                                    currentUser: currentUser,
                                    assignments: viewModel.assignments
                                )
                            } label: {
                                // Course section card visual representation
                                /// Uses reusable CourseSectionCard component with consistent styling
                                CourseSectionCard(section: section, onTap: nil)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .background(MountainlandColors.platinum.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .task {
            // Load assignments when view appears
            /// Triggers asynchronous API call to fetch assignment data
            /// Provides data for assignment lists accessed through navigation
            await viewModel.loadAssignments()
        }
    }
}

// MARK: - Preview
/// Xcode preview for design and layout testing during development
/// Provides live preview with sample student data and interaction simulation
#Preview {
    CourseSectionView(currentUser: Student.demoStudents[0])
}
