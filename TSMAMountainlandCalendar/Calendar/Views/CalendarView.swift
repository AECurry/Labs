//
//  CalendarView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// *Calendar View
/// Main calendar screen displaying monthly calendar grid and detailed lesson info
/// Supports interactive date selection, month navigation, and toggle to year overview
struct CalendarView: View {
    
    // *State Properties
    @State private var viewModel = CalendarViewModel()  // ViewModel managing calendar data
    @State private var showingYearView = false          // Tracks whether the year overview is visible
    
    var body: some View {
        VStack(spacing: 0) {
            // ✅ App header with edge-to-edge background
            AppHeader(
                title: "iOS Development",
                subtitle: "Fall/Spring - 25/26"
            )
            
            // *Year Overview Toggle
            /// Shows YearView when showingYearView is true
            /// Handles month selection or back action to toggle visibility
            if showingYearView {
                YearView(
                    selectedDate: $viewModel.selectedDate,
                    onMonthSelected: {
                        withAnimation { showingYearView = false }
                    },
                    onBack: {
                        withAnimation { showingYearView = false }
                    }
                )
            } else {
                
                // *Monthly Calendar Scroll Container
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // *Month Header
                        /// Displays the current month and year
                        /// Includes calendar button to toggle year overview
                        HStack {
                            Text(monthYearText)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(MountainlandColors.smokeyBlack)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation { showingYearView = true }
                            }) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(MountainlandColors.burgundy1)
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        
                        // *Calendar Grid
                        /// Shows the MonthView grid with date selection binding
                        /// Triggers ViewModel update when selected date changes
                        MonthView(selectedDate: $viewModel.selectedDate)
                            .onChange(of: viewModel.selectedDate) { oldValue, newValue in
                                Task {
                                    await viewModel.selectDate(newValue)
                                }
                            }
                        
                        // *Selected Day's Lesson Cards
                        /// Displays the stacked lesson cards for the currently selected date
                        CalendarCardStack(viewModel: viewModel)
                    }
                    .padding(.top, 0)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        // MARK: - Global Background
        /// ✅ ADDED: Platinum background for entire screen
        .background(MountainlandColors.platinum.ignoresSafeArea())
        
        // *Data Loading Task
        /// Loads all calendar entries when the view appears
        .task {
            await viewModel.loadCalendarData()
        }
    }
    
    // *Helpers
    /// Formats the selected date into "Month Year" for the header
    private var monthYearText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: viewModel.selectedDate)
    }
}

// *Preview
/// Xcode live preview for CalendarView
#Preview {
    CalendarView()
}
