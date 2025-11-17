//
//  CourseSectionView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Course Section View
/// Main screen displaying all course sections with navigation to assignment lists
/// Serves as the entry point for students to access assignments by course module
/// Each course section is shown as a tappable card that takes them to the assignment list for that specific course.
/// This is essentially the "course catalog" screen that organizes the student's entire curriculum into manageable sections they can explore.
struct CourseSectionView: View {
    // MARK: - Properties
    @State private var sections = CourseSection.demoData  // Loads sample course sections
    @Environment(\.dismiss) private var dismiss           // Environment value for closing view
    let currentUser: Student                              // The student viewing the sections
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Header with Profile and Back Button
                /// Custom navigation bar with back button and user profile
                HStack {
                    // MARK: - Back Button
                    /// Returns to previous screen when tapped
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 8)  // Extra padding for comfortable tapping
                    
                    Spacer()  // Pushes profile to trailing edge
                    
                    // MARK: - User Profile Circle
                    /// Displays student initials in branded circular avatar
                    ZStack {
                        Circle()
                            .fill(MountainlandColors.burgundy2)  // Brand color background
                            .frame(width: 40, height: 40)        // Fixed size for consistency
                        
                        Text(currentUser.initials)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 8)  // Side padding for visual balance
                    
                }
                .padding(.horizontal, 16)  // Side margins for header content
                .padding(.top, 16)         // Top safe area padding
                .padding(.bottom, 32)      // Extra bottom padding for visual separation
                
                // MARK: - Screen Title
                /// Clear label indicating this screen's purpose
                Text("Course Assignments")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)  // Centers text within available width
                    .padding(.bottom, 40)        // Substantial padding before content
                
                // MARK: - Course Sections Content
                /// Scrollable list of all available course sections
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        // MARK: - Course Section Cards
                        /// Creates a navigable card for each course section
                        ForEach(sections) { section in
                            NavigationLink {
                                // MARK: - Navigation Destination
                                /// Shows assignment list when section card is tapped
                                AssignmentListView(
                                    currentUser: currentUser,
                                    courseSection: section.toCurriculumModule()  // Converts to assignment format
                                )
                            } label: {
                                // MARK: - Section Card Display
                                /// Uses CourseSectionCard in static mode (no onTap needed)
                                CourseSectionCard(section: section, onTap: nil)  // NavigationLink handles tapping
                            }
                            .padding(.horizontal, 16)  // Side padding for card alignment
                        }
                    }
                }
            }
            .background(MountainlandColors.platinum.ignoresSafeArea())  // Page background color
            .navigationBarHidden(true)  // Hides default navigation bar for custom implementation
        }
    }
}
