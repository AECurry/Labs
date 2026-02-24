//
//  CalendarGridView.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import SwiftUI

struct CalendarGridView: View {
    @Bindable var viewModel: CalendarViewModel
    
    // MARK: - Design Constants
    private let gridWidth: CGFloat = 350
    private let dayLabelFontSize: CGFloat = 12
    private let dayLabelSpacing: CGFloat = 8
    
    // Days of week labels
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 16) {
            // Calendar header (month navigation)
            CalendarHeaderView(
                monthYear: viewModel.monthYearString,
                onPreviousMonth: {
                    viewModel.moveToPreviousMonth()
                },
                onNextMonth: {
                    viewModel.moveToNextMonth()
                },
                onTodayTap: {
                    viewModel.moveToToday()
                }
            )
            
            // Days of week labels
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.custom("Inter-SemiBold", size: dayLabelFontSize))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, dayLabelSpacing)
            
            // Calendar grid
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
                spacing: 8
            ) {
                ForEach(Array(viewModel.daysInMonth().enumerated()), id: \.offset) { _, date in
                    CalendarDayCell(
                        date: date,
                        isSelected: date.map { viewModel.isSelected($0) } ?? false,
                        isToday: date.map { viewModel.isToday($0) } ?? false,
                        hasData: date.map { viewModel.hasData(for: $0) } ?? false,
                        onTap: {
                            if let date = date {
                                Task {
                                    await viewModel.selectDate(date)
                                }
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(width: gridWidth)
        .task {
            await viewModel.loadDatesWithData()
        }
    }
}

#Preview {
    @Previewable @State var viewModel = CalendarViewModel()
    
    CalendarGridView(viewModel: viewModel)
        .background(MasukiColors.adaptiveBackground)
        .padding()
}

