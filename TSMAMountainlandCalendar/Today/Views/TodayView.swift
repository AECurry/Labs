//
//  TodayView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Today View
/// Main screen for the Today tab / Home Screen - displays today's lesson plan and assignments for Students or "No Lesson Today' if nothing is scheduled

struct TodayView: View {
    // MARK: - State Properties
    @State private var viewModel = TodayViewModel()  // ViewModel manages data loading
    @State private var showingFeedbackForm = false  // Controls feedback form sheet display
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Date Header
            /// Shows today's date with calendar styling (non-functional button in this context)
            DateHeaderView(date: Date(), onCalendarTap: {})  // Empty handler for Today tab
            
            // MARK: - Content Scroll Area
            /// Scrollable container for lesson cards or empty state
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Loading State
                    if viewModel.isLoading {
                        ProgressView("Loading today's lesson...")
                            .padding()
                    }
                    // MARK: - Error State
                    else if let error = viewModel.error {
                        CardView(
                            emoji: "⚠️",
                            title: "Error Loading Lesson",
                            content: error,
                            isTopCard: true
                        )
                    }
                    // MARK: - Conditional Content Display
                    /// Shows either full lesson plan or "No Lesson" card
                    else if let entry = viewModel.dailyContent {
                        // MARK: - Lesson Plan Cards
                        /// Displays all lesson content in stacked card format
                        LessonPlanCardsView(
                            entry: entry,
                            showSubmitFeedback: true,  // Enable feedback in Today tab
                            onSubmitFeedback: { showingFeedbackForm = true }  // Show feedback form
                        )
                        

                    } else {
                        // MARK: - No Lesson State
                        /// Displayed when no lesson is scheduled for today
                        CardView(
                            emoji: "📅",
                            title: "No Lesson Today",
                            content: "No lesson scheduled for today",
                            isTopCard: true  // Standalone card with rounded corners
                        )
                    }
                }
                .padding(.top, 0)        // No top padding (header provides spacing)
                .padding(.horizontal, 16) // Side padding matching header
                .padding(.bottom, 24)    // Bottom padding for scroll comfort
            }
        }
        // MARK: - Data Loading
        /// Load today's content when view appears
        .task {
            await viewModel.loadDailyContent()
        }
        // MARK: - Feedback Form Sheet
        /// Modal presentation for submitting feedback about today's lesson
        .sheet(isPresented: $showingFeedbackForm) {
            SubmitFeedbackView()
        }
    }
}

#Preview {
    TodayView()
}
