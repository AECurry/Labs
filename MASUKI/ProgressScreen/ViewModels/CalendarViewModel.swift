//
//  CalendarViewModel.swift
//  MASUKI
//
//  Created by AnnElaine on 2/2/26.
//

import Foundation
import Observation

@Observable
final class CalendarViewModel {
    // Current state
    var selectedDate: Date = Date()
    var currentMonth: Date = Date()
    var selectedDayData: DailyProgressData?
    var datesWithData: Set<Date> = []
    var isLoading = false
    
    private let repository = CalendarRepository()
    private let calendar = Calendar.current
    
    // MARK: - Month Navigation
    
    func moveToNextMonth() {
        guard let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) else { return }
        currentMonth = newMonth
        Task {
            await loadDatesWithData()
        }
    }
    
    func moveToPreviousMonth() {
        guard let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) else { return }
        currentMonth = newMonth
        Task {
            await loadDatesWithData()
        }
    }
    
    func moveToToday() {
        currentMonth = Date()
        selectedDate = Date()
        Task {
            await selectDate(Date())
        }
    }
    
    // MARK: - Date Selection
    
    @MainActor
    func selectDate(_ date: Date) async {
        isLoading = true
        selectedDate = date
        
        // Fetch data for selected date
        selectedDayData = await repository.fetchData(for: date)
        
        isLoading = false
    }
    
    // MARK: - Load Month Data
    
    @MainActor
    func loadDatesWithData() async {
        // Get all dates in current month that have walking data
        datesWithData = repository.getDatesWithData(in: currentMonth)
    }
    
    // MARK: - Calendar Helpers
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstDayOfMonth = monthInterval.start
        let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end)!
        
        // Get weekday of first day (1 = Sunday, 7 = Saturday)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Calculate number of days
        let daysInMonth = calendar.dateComponents([.day], from: firstDayOfMonth, to: lastDayOfMonth).day! + 1
        
        // Create array with nil for empty leading days
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        // Add actual days
        for day in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    func hasData(for date: Date) -> Bool {
        datesWithData.contains(calendar.startOfDay(for: date))
    }
    
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
}

