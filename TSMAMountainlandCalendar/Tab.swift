//
//  Tab.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/8/26.
//

import Foundation

// MARK: - Tab Enum
/// Defines all available tabs in the main navigation
/// Used with SwiftUI's native TabView for type-safe navigation
enum Tab: String, CaseIterable, Identifiable {
    case today
    case calendar
    case assignments
    
    // MARK: - Identifiable Conformance
    var id: String { rawValue }
    
    // MARK: - Display Properties
    
    /// The text label shown in the tab bar
    var title: String {
        switch self {
        case .today:       return "Today"
        case .calendar:    return "Calendar"
        case .assignments: return "Assignments"
        }
    }
    
    /// The SF Symbol icon shown in the tab bar
    var icon: String {
        switch self {
        case .today:       return "house.fill"
        case .calendar:    return "calendar"
        case .assignments: return "list.clipboard.fill"
        }
    }
}
