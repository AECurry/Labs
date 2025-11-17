//
//  AssignmentAndRosterView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

// Parent View for Views/Assignments
import SwiftUI

// MARK: - Assignment and Roster View
/// Main entry screen displaying all students as selectable profile cards
/// Serves as the launch point where users choose their identity to access the app
/// Acts as a student directory and authentication gateway
struct AssignmentAndRosterView: View {
    // MARK: - Properties
    private let students = Student.demoStudents  // Loads sample student data for development
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            // MARK: - Scrollable Student List
            /// Vertical list of student profile cards with automatic scrolling
            ScrollView {
                // MARK: - Student Cards Container
                /// Efficient lazy-loading stack for optimal performance with many students
                LazyVStack(spacing: 16) {
                    // MARK: - Student Profile Cards
                    /// Creates a tappable card for each student in the roster
                    ForEach(students) { student in
                        NavigationLink {
                            // MARK: - Navigation Destination
                            /// Navigates to login screen when student card is tapped
                            LoginView(student: student)  // Passes selected student to login
                        } label: {
                            // MARK: - Card Display
                            /// Uses custom StudentProfileCard component for consistent styling
                            StudentProfileCard(student: student) // Using the new component
                        }
                        .buttonStyle(PlainButtonStyle())  // Removes default button styling
                    }
                }
                .padding(.top, 16) // Space between the top card and the AppHeader
            }
            .background(MountainlandColors.platinum.ignoresSafeArea())  // App background color
            .navigationBarTitleDisplayMode(.inline)  // Compact navigation bar style
        }
    }
}

// MARK: - Preview
/// Xcode preview for design and layout testing
/// Shows the student roster view with sample data
#Preview {
    AssignmentAndRosterView()
}
