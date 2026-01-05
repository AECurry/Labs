//
//  CompletedSession.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import Foundation

struct CompletedSession: Identifiable, Codable {
    let id: UUID
    let duration: DurationOption
    let music: MusicOption
    let startTime: Date
    let endTime: Date
    let totalDuration: TimeInterval
    
    var actualDuration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }
    
    static func saveAll(_ sessions: [CompletedSession]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(sessions)
            UserDefaults.standard.set(encoded, forKey: "completedSessions")
        } catch {
            print("Error saving completed sessions: \(error)")
        }
    }
    
    static func loadAll() -> [CompletedSession] {
        guard let data = UserDefaults.standard.data(forKey: "completedSessions") else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([CompletedSession].self, from: data)
        } catch {
            print("Error loading completed sessions: \(error)")
            return []
        }
    }
}
