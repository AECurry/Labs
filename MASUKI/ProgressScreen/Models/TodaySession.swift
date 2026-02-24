//
//  TodaySession.swift
//  MASUKI
//
//  Created by AnnElaine on 1/28/26.
//

import Foundation

struct TodaySession: Identifiable, Codable, Equatable {  // ← ADDED Codable, Equatable
    let id: UUID
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let distance: Double
    let calories: Double
    
    var startHour: Int {
        Calendar.current.component(.hour, from: startTime)
    }
    
    var startMinute: Int {
        Calendar.current.component(.minute, from: startTime)
    }
    
    var timeRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return "\(formatter.string(from: startTime)) - \(formatter.string(from: endTime))"
    }
    
    // MARK: - Codable Implementation (Automatic with Codable protocol)
    // SwiftUI auto-synthesizes this, but we need to make sure all properties are Codable
    // UUID, Date, TimeInterval, Double are all Codable by default
}

