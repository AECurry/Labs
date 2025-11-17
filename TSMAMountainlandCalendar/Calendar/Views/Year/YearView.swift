//
//  YearView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Year View
/// Academic year overview showing all months in the school year (August-May)
/// Provides high-level navigation to jump between months quickly without having to scroll through the calendar month by month!
struct YearView: View {
    // MARK: - Properties
    @Binding var selectedDate: Date  // Currently selected date for navigation
    let onMonthSelected: () -> Void  // Callback when a month is chosen
    let onBack: () -> Void           // Callback to return to previous view
    
    // MARK: - School Year Data
    /// Hardcoded academic year structure from August 2025 to May 2026
    /// Follows typical school calendar (not calendar year)
    private let schoolYear: [SchoolYearSection] = [
        SchoolYearSection(
            year: "2025",
            months: [
                SchoolMonth(name: "August", month: 8, year: 2025),
                SchoolMonth(name: "September", month: 9, year: 2025),
                SchoolMonth(name: "October", month: 10, year: 2025),
                SchoolMonth(name: "November", month: 11, year: 2025),
                SchoolMonth(name: "December", month: 12, year: 2025)
            ]
        ),
        SchoolYearSection(
            year: "2026",
            months: [
                SchoolMonth(name: "January", month: 1, year: 2026),
                SchoolMonth(name: "February", month: 2, year: 2026),
                SchoolMonth(name: "March", month: 3, year: 2026),
                SchoolMonth(name: "April", month: 4, year: 2026),
                SchoolMonth(name: "May", month: 5, year: 2026)
            ]
        )
    ]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Navigation Header
            /// Back button to return to previous screen
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(MountainlandColors.smokeyBlack)
                        .frame(width: 40, height: 40)
                }
                Spacer()  // Pushes back button to leading edge
            }
            .padding(.top, 0)
            .padding(.horizontal, 16)
            
            // MARK: - Year Overview Scroll
            /// Scrollable container for academic year sections
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(schoolYear) { yearSection in
                        YearSectionView(
                            yearSection: yearSection,
                            selectedDate: $selectedDate,
                            onMonthSelected: onMonthSelected
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
        }
    }
}

// MARK: - School Year Section Model
/// Represents an academic year with its associated months
struct SchoolYearSection: Identifiable {
    let id = UUID()
    let year: String          // Display year (e.g., "2025")
    let months: [SchoolMonth] // Months belonging to this year section
}

// MARK: - School Month Model
/// Represents an individual month in the academic calendar
struct SchoolMonth: Identifiable {
    let id = UUID()
    let name: String   // Full month name (e.g., "August")
    let month: Int     // Month number (1-12)
    let year: Int      // Year number (e.g., 2025)
    
    /// Converts month/year to actual Date object for navigation
    var date: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1  // Always first day of month
        return calendar.date(from: components) ?? Date()
    }
}

// MARK: - Year Section View
/// Displays a single academic year with its months in a grid
struct YearSectionView: View {
    let yearSection: SchoolYearSection
    @Binding var selectedDate: Date
    let onMonthSelected: () -> Void
    
    // 2-column grid for month cards
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Year Header
            /// Displays the year title (e.g., "2025")
            Text(yearSection.year)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(MountainlandColors.smokeyBlack)
                .padding(.horizontal, 4)
            
            // MARK: - Months Grid
            /// 2-column grid of month cards
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(yearSection.months) { month in
                    YearMonthCard(
                        month: month,
                        isSelected: false, // No highlighting selected month
                        onSelect: {
                            selectedDate = month.date    // Update selected date
                            onMonthSelected()           // Trigger navigation
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Year Month Card
/// Individual month card in the year overview grid
struct YearMonthCard: View {
    let month: SchoolMonth
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Text(month.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(MountainlandColors.smokeyBlack)
                .frame(maxWidth: .infinity, minHeight: 56)  // Consistent card size
                .background(Color.white)                    // White card background
                .cornerRadius(16)                          // Rounded corners
                .shadow(
                    color: .black.opacity(0.1),            // Subtle elevation shadow
                    radius: 3,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(PlainButtonStyle())  // Remove default button styling
    }
}
