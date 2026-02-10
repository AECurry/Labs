//
//  TodayView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Today View
/// Main screen for the Today tab / Home screen
/// Displays the current day's lesson plan, assignments, and feedback options
/// Serves as the primary landing page for students
struct TodayView: View {
    
    // MARK: - Properties
    
    /// Callback triggered when the calendar icon is tapped
    /// Allows navigation to the Calendar tab
    let onSwitchToCalendar: () -> Void
    
    // MARK: - State Properties
    
    /// ViewModel responsible for loading and managing today's content
    @State private var viewModel = TodayViewModel()
    
    /// Controls presentation of the feedback submission sheet
    @State private var showingFeedbackForm = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - App Header
            /// Custom branded header with logo and course info
            AppHeader(
                title: "iOS Development",
                subtitle: "Fall/Spring - 25/26"
            )
            
            // MARK: - Spacing Between Header and Date Card
            /// ✅ ADDED: Visual breathing room between header and content
            Spacer()
                .frame(height: 24)  // Adjust this value to your preference (12-24pt typical)
            
            // MARK: - Date Header with Calendar Navigation
            /// Burgundy date card with calendar icon for tab switching
            DateHeaderView(
                date: Date(),
                onCalendarTap: onSwitchToCalendar
            )
            
            // MARK: - Scrollable Lesson Content
            /// Main content area with lesson cards
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Loading state
                    if viewModel.isLoading {
                        ProgressView("Loading today's lesson...")
                            .padding()
                    }
                    
                    // Error state
                    else if let error = viewModel.errorMessage {
                        CardView(
                            emoji: "⚠️",
                            title: "Error Loading Lesson",
                            content: error,
                            isTopCard: true
                        )
                    }
                    
                    // Lesson content
                    else if let entry = viewModel.dailyContent {
                        LessonPlanCardsView(
                            entry: entry,
                            showSubmitFeedback: true,
                            onSubmitFeedback: {
                                showingFeedbackForm = true
                            },
                            hasHeaderAbove: true  // Today tab has DateHeaderView above
                        )
                    }
                    
                    // No lesson scheduled
                    else {
                        CardView(
                            emoji: "📅",
                            title: "No Lesson Today",
                            content: "No lesson scheduled for today",
                            isTopCard: true
                        )
                    }
                }
                .padding(.top, 0)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        // MARK: - Global Background
        /// Platinum background for entire screen
        .background(MountainlandColors.platinum.ignoresSafeArea())
        
        // MARK: - Data Loading
        /// Load today's content when view appears
        .task {
            await viewModel.loadDailyContent()
        }
        
        // MARK: - Feedback Sheet
        /// Feedback submission sheet
        .sheet(isPresented: $showingFeedbackForm) {
            SubmitFeedbackView()
        }
    }
}

// MARK: - Preview
/// Xcode preview for layout and interaction testing
#Preview {
    TodayView(onSwitchToCalendar: {
        print("Calendar navigation tapped in preview")
    })
}
