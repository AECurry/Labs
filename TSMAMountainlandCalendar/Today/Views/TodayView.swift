//
//  TodayView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Today View
/// Main screen for the Today tab / Home Screen - displays today's lesson plan and assignments
/// Serves as the primary landing page for students showing daily instructional content
/// Provides access to today's lessons, assignments, and feedback submission features
/// Follows MVVM architecture with clean separation between view logic and data management
struct TodayView: View {
    // MARK: - Properties
    
    /// Callback closure triggered when user taps the calendar navigation icon
    /// Allows navigation to Calendar tab for date selection and month overview
    /// Implements loose coupling between Today and Calendar components
    let onSwitchToCalendar: () -> Void
    
    // MARK: - State Properties
    
    /// ViewModel instance managing data loading, state, and business logic for Today view
    /// Uses @State wrapper for @Observable ViewModel to enable reactive UI updates
    /// Automatically handles ViewModel lifecycle and state preservation
    @State private var viewModel = TodayViewModel()
    
    /// Boolean state controlling the presentation of the feedback submission sheet
    /// Manages modal presentation lifecycle for user feedback interface
    @State private var showingFeedbackForm = false
    
    // MARK: - Body
    /// Main view hierarchy defining the Today screen layout and functionality
    /// Organizes content into vertical stack with header, date display, and lesson cards
    /// Implements reactive UI updates based on ViewModel state changes
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Spacing Between App Header and Date Header
            /// Adds vertical separation between the main app header and today's date header
            /// Provides visual breathing room and proper content hierarchy
            /// Fixed height ensures consistent layout across different device sizes
            Spacer()
                .frame(height: 48)
            
            // MARK: - Date Header
            /// Shows today's date with functional calendar navigation button
            /// Displays live-updating date with formatted presentation
            /// Includes tappable calendar icon for navigation to Calendar tab
            DateHeaderView(date: Date(), onCalendarTap: onSwitchToCalendar)
            
            // MARK: - Content Scroll Area
            /// Scrollable container for lesson cards or empty state messages
            /// Enables vertical scrolling for content that exceeds screen height
            /// Maintains consistent padding and spacing for visual polish
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Loading State
                    /// Displays progress indicator while fetching lesson data from API
                    /// Shows user-friendly loading message during asynchronous operations
                    /// Provides visual feedback that content is being retrieved
                    if viewModel.isLoading {
                        ProgressView("Loading today's lesson...")
                            .padding()
                    }
                    // MARK: - Error State
                    /// Displays error card when data loading fails
                    /// Shows user-friendly error message with warning emoji
                    /// Provides clear feedback for network or authentication issues
                    else if let error = viewModel.errorMessage {
                        CardView(
                            emoji: "⚠️",
                            title: "Error Loading Lesson",
                            content: error,
                            isTopCard: true
                        )
                    }
                    // MARK: - Conditional Content Display
                    /// Shows either complete lesson plan or "No Lesson Today" message
                    /// Dynamically renders content based on API response and schedule
                    /// Maintains consistent card-based layout regardless of content state
                    else if let entry = viewModel.dailyContent {
                        // MARK: - Lesson Plan Cards
                        /// Displays all lesson content in stacked card format
                        /// Shows comprehensive instructional details with organized sections
                        /// Includes feedback submission button for user input
                        LessonPlanCardsView(
                            entry: entry,
                            showSubmitFeedback: true,  // Enable feedback in Today tab
                            onSubmitFeedback: { showingFeedbackForm = true }  // Show feedback form
                        )
                    } else {
                        // MARK: - No Lesson State
                        /// Displayed when no lesson is scheduled for the current date
                        /// Shows friendly message with calendar emoji for visual interest
                        /// Uses standalone card appearance with rounded corners
                        CardView(
                            emoji: "📅",
                            title: "No Lesson Today",
                            content: "No lesson scheduled for today",
                            isTopCard: true  // Standalone card with rounded corners
                        )
                    }
                }
                .padding(.top, 0)        // No top padding (date header provides spacing)
                .padding(.horizontal, 16) // Side padding matching header width
                .padding(.bottom, 24)    // Bottom padding for scroll comfort
            }
        }
        // MARK: - Data Loading
        /// Loads today's content when view appears using Swift Concurrency
        /// Triggers asynchronous API call to fetch current day's lesson data
        /// Automatically handles loading states and error conditions
        .task {
            await viewModel.loadDailyContent()
        }
        // MARK: - Feedback Form Sheet
        /// Modal presentation for submitting feedback about today's lesson
        /// Slides up from bottom with custom feedback submission interface
        /// Maintains separate presentation state from main view hierarchy
        .sheet(isPresented: $showingFeedbackForm) {
            SubmitFeedbackView()
        }
    }
}

// MARK: - Preview
/// Xcode preview for design and layout testing during development
/// Provides live preview with sample data and interaction simulation
/// Includes mock callback implementation for preview functionality
#Preview {
    TodayView(onSwitchToCalendar: {
        // Preview callback - simulates calendar navigation in Xcode preview
        print("Calendar navigation tapped in preview")
    })
}
