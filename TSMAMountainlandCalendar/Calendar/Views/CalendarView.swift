//
//  CalendarView.swift (FIXED VERSION)
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Calendar View
/// Main calendar screen that toggles between detailed monthly calendar and academic year picker

struct CalendarView: View {
    // MARK: - State Properties
    @State private var selectedDate = Date()       // Currently selected date in the calendar
    @State private var showingYearView = false     // Controls whether year picker is visible
    @State private var viewModel = TodayViewModel() // ViewModel for loading lesson data
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Conditional View Display
            /// Switches between Year Overview and Month Detail views
            if showingYearView {
                // MARK: - Year Overview Mode
                /// Shows academic year picker for quick month navigation
                YearView(
                    selectedDate: $selectedDate,    // Pass selected date binding
                    onMonthSelected: {
                        // Animation when user selects a month from year view
                        withAnimation {
                            showingYearView = false  // Return to month view
                        }
                        // Load content for newly selected date
                        Task {
                            viewModel.date = selectedDate
                            await viewModel.loadDailyContent()
                        }
                    },
                    onBack: {
                        // Animation when user taps back button
                        withAnimation {
                            showingYearView = false  // Return to month view
                        }
                    }
                )
            } else {
                // MARK: - Month Detail Mode
                /// Shows the main calendar interface with monthly grid and lesson cards
                ScrollView {
                    VStack(spacing: 16) {
                        // MARK: - Month Header with Year View Button
                        /// NEW: Separate header that can be tapped to switch to year view
                        HStack {
                            Text(monthYearText)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(MountainlandColors.smokeyBlack)
                            
                            Spacer()
                            
                            // Tappable button to switch to year view
                            Button(action: {
                                withAnimation {
                                    showingYearView = true
                                }
                            }) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(MountainlandColors.burgundy1)
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        
                        // MARK: - Calendar Grid WITHOUT tap gesture
                        /// ✅ FIXED: Removed .onTapGesture so individual dates can be selected
                        MonthView(selectedDate: $selectedDate)
                            .onChange(of: selectedDate) { oldValue, newValue in
                                // ✅ Load content whenever selected date changes
                                Task {
                                    viewModel.date = newValue
                                    await viewModel.loadDailyContent()
                                }
                            }
                        
                        // MARK: - Selected Day's Lesson Card Stack
                        /// Displays lesson cards for the selected date below the calendar
                        CalendarCardStack(todayViewModel: viewModel)
                    }
                    .padding(.top, 0)        // No top padding (header provides spacing)
                    .padding(.horizontal, 16) // Side padding for content alignment
                    .padding(.bottom, 24)    // Bottom padding for scroll comfort
                }
            }
        }
        .task {
            // ✅ Load initial content when view appears
            viewModel.date = selectedDate
            await viewModel.loadDailyContent()
        }
    }
    
    // MARK: - Computed Properties
    /// Formats the current month and year for display (e.g., "November 2024")
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }
}

#Preview {
    CalendarView()
}
