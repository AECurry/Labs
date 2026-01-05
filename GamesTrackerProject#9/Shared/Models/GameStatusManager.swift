//
//  GameStatusManager.swift
//  GamesTrackerProject#9
//

import Foundation
import SwiftData
import SwiftUI

/// Manages automatic game status updates
@MainActor
final class GameStatusManager {
    static let shared = GameStatusManager()
    private var timer: Timer?
    private var isMonitoring = false
    private weak var currentModelContext: ModelContext?
    
    private init() {}
    
    /// Start automatic status monitoring
    func startMonitoring(modelContext: ModelContext) {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        currentModelContext = modelContext
        
        // Check immediately
        updateAllGameStatuses()
        
        // Set up timer to check every 60 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.updateAllGameStatuses()
            }
        }
    }
    
    /// Stop monitoring
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        isMonitoring = false
        currentModelContext = nil
    }
    
    /// Update all games' statuses
    private func updateAllGameStatuses() {
        guard let modelContext = currentModelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<Game>()
            let games = try modelContext.fetch(descriptor)
            
            var needsSave = false
            
            for game in games {
                let previousStatus = game.status
                game.updateStatusBasedOnCurrentTime()
                
                if game.status != previousStatus {
                    needsSave = true
                    print("🔄 Game \(game.id) status changed: \(previousStatus.rawValue) → \(game.status.rawValue)")
                }
            }
            
            if needsSave {
                try modelContext.save()
            }
        } catch {
            print("❌ Error updating game statuses: \(error)")
        }
    }
    
    /// Force complete a game
    func completeGame(_ gameId: UUID) throws {
        guard let modelContext = currentModelContext else { return }
        
        let descriptor = FetchDescriptor<Game>(
            predicate: #Predicate { $0.id == gameId }
        )
        
        if let game = try modelContext.fetch(descriptor).first {
            game.status = .completed
            game.timeRemaining = "0:00:00"
            try modelContext.save()
        }
    }
    
    /// Force start a game
    func startGame(_ gameId: UUID) throws {
        guard let modelContext = currentModelContext else { return }
        
        let descriptor = FetchDescriptor<Game>(
            predicate: #Predicate { $0.id == gameId }
        )
        
        if let game = try modelContext.fetch(descriptor).first {
            game.status = .live
            if game.timeRemaining == "0:00:00" {
                game.timeRemaining = "1:00:00"
            }
            try modelContext.save()
        }
    }
}
