//
//  WalkSession.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import Foundation

struct WalkSession: Identifiable, Codable {
    let id: UUID
    let duration: DurationOption
    let music: MusicOption
    let startTime: Date
    var endTime: Date?
    var isCompleted: Bool = false
    var pausedAt: TimeInterval?
    
    init(
        id: UUID = UUID(),
        duration: DurationOption,
        music: MusicOption,
        startTime: Date = Date(),
        endTime: Date? = nil,
        isCompleted: Bool = false,
        pausedAt: TimeInterval? = nil
    ) {
        self.id = id
        self.duration = duration
        self.music = music
        self.startTime = startTime
        self.endTime = endTime
        self.isCompleted = isCompleted
        self.pausedAt = pausedAt
    }
    
    var durationInSeconds: TimeInterval {
        TimeInterval(duration.minutes * 60)
    }
    
    var elapsedTime: TimeInterval {
        if let pausedAt = pausedAt {
            return pausedAt
        } else if isCompleted {
            return durationInSeconds
        } else {
            return Date().timeIntervalSince(startTime)
        }
    }
    
    var remainingTime: TimeInterval {
        max(0, durationInSeconds - elapsedTime)
    }
    
    var progress: Double {
        min(1.0, elapsedTime / durationInSeconds)
    }
    
    static func saveActive(_ session: WalkSession) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encoded = try encoder.encode(session)
            UserDefaults.standard.set(encoded, forKey: "activeWalkSession")
        } catch {
            print("Error saving active session: \(error)")
        }
    }
    
    static func loadActive() -> WalkSession? {
        guard let data = UserDefaults.standard.data(forKey: "activeWalkSession") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(WalkSession.self, from: data)
        } catch {
            print("Error loading active session: \(error)")
            return nil
        }
    }
    
    static func clearActive() {
        UserDefaults.standard.removeObject(forKey: "activeWalkSession")
    }
    
    static func save(_ session: WalkSession) {
        UserDefaults.standard.set(session.duration.rawValue, forKey: "lastDuration")
        UserDefaults.standard.set(session.music.id, forKey: "lastMusic")
    }
    
    // NEW METHOD - for WalkSession screen
    static func completeSession(_ session: WalkSession) -> CompletedSession {
        var completed = session
        completed.endTime = Date()
        completed.isCompleted = true
        
        // Save to completed sessions list
        var completedSessions = CompletedSession.loadAll()
        let completedSession = CompletedSession(
            id: completed.id,
            duration: completed.duration,
            music: completed.music,
            startTime: completed.startTime,
            endTime: completed.endTime!,
            totalDuration: completed.durationInSeconds
        )
        completedSessions.append(completedSession)
        CompletedSession.saveAll(completedSessions)
        
        // Clear active session
        clearActive()
        
        return completedSession
    }
}

