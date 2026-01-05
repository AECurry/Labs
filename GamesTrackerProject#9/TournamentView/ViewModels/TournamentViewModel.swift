//
//  TournamentViewModel.swift
//  GamesTrackerProject#9
//

import SwiftUI
import SwiftData
import Observation

// MARK: - Main ViewModel with Dynamic Sorting
@Observable
class TournamentViewModel {
    // MARK: - Properties
    var games: [Game] = []
    var isLoading = false
    var errorMessage: String?
    
    private var modelContext: ModelContext
    private var statusTimer: Timer?
    
    // MARK: - Computed Properties
    /// Returns matches sorted: Live → Upcoming → Completed
    var sortedMatches: [TournamentMatch] {
        return games.sorted { game1, game2 in
            // 1. Sort by display status priority
            let priority1 = displayStatusPriority(for: game1)
            let priority2 = displayStatusPriority(for: game2)
            
            if priority1 != priority2 {
                return priority1 < priority2 // Lower number = higher in list
            }
            
            // 2. Same status? Sort by date (most recent first)
            return game1.date > game2.date
        }
        .map { TournamentMatch(game: $0) }
    }
    
    // MARK: - Helper Methods
    private func displayStatusPriority(for game: Game) -> Int {
        // Games that should show as completed go to bottom
        if game.shouldShowAsCompleted {
            return 2 // Completed priority
        }
        
        switch game.status {
        case .live: return 0      // Highest priority - TOP
        case .upcoming: return 1  // Middle priority
        case .completed: return 2 // Lowest priority
        case .postponed: return 3 // Very bottom
        }
    }
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // Start automatic status monitoring
        startStatusMonitoring()
    }
    
    deinit {
        stopStatusMonitoring()
    }
    
    // MARK: - Automatic Status Management
    /// Updates all game statuses based on current time
    private func updateGameStatuses() {
        var needsSave = false
        
        for game in games {
            let previousStatus = game.status
            game.updateStatusBasedOnCurrentTime()
            
            if game.status != previousStatus {
                needsSave = true
                print("🔄 Game status updated: \(previousStatus.rawValue) → \(game.status.rawValue)")
            }
        }
        
        if needsSave {
            saveContext()
        }
    }
    
    /// Start automatic status monitoring
    private func startStatusMonitoring() {
        // Update immediately
        updateGameStatuses()
        
        // Set up timer to check every 60 seconds
        statusTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateGameStatuses()
        }
    }
    
    /// Stop monitoring
    private func stopStatusMonitoring() {
        statusTimer?.invalidate()
        statusTimer = nil
    }
    
    // MARK: - Data Loading
    @MainActor
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let descriptor = FetchDescriptor<Game>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            
            games = try modelContext.fetch(descriptor)
            print("✅ Loaded \(games.count) games")
            
            // Update statuses based on current time
            updateGameStatuses()
            
            // Debug: Print sorted order
            printSortedOrder()
            
        } catch {
            errorMessage = "Failed to load games: \(error.localizedDescription)"
            print("❌ Error loading games: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Debug Helper
    private func printSortedOrder() {
        print("📊 ===== SORTED ORDER =====")
        for (index, match) in sortedMatches.enumerated() {
            print("   \(index + 1). [\(match.statusDisplay)] \(match.team1Name) vs \(match.team2Name)")
            if let game = findGame(by: match.id) {
                print("       Status: \(game.status.rawValue), Scores: \(game.team1.score)-\(game.team2.score)")
                print("       Should show as completed: \(game.shouldShowAsCompleted)")
            }
        }
        print("📊 ===== END ORDER =====")
    }
    
    // MARK: - Data Refresh
    @MainActor
    func refreshData() async {
        updateGameStatuses()
        await loadData()
    }
    
    // MARK: - Filtering for Segmented Control
    func matches(for status: MatchStatus) -> [TournamentMatch] {
        switch status {
        case .all:
            return sortedMatches
            
        case .live:
            // Only show ACTUALLY live games (not shouldShowAsCompleted)
            return sortedMatches.filter { match in
                guard let game = findGame(by: match.id) else { return false }
                return !game.shouldShowAsCompleted && game.status == .live
            }
            
        case .upcoming:
            // Only show ACTUALLY upcoming games (not shouldShowAsCompleted)
            return sortedMatches.filter { match in
                guard let game = findGame(by: match.id) else { return false }
                return !game.shouldShowAsCompleted && game.status == .upcoming
            }
            
        case .completed:
            // Show both actual completed AND games that should show as completed
            return sortedMatches.filter { match in
                guard let game = findGame(by: match.id) else { return false }
                return game.shouldShowAsCompleted || game.status == .completed
            }
        }
    }
    
    // MARK: - Game State Management
    /// Start a game (upcoming → live)
    func startGame(_ gameId: UUID) {
        guard let game = games.first(where: { $0.id == gameId }) else { return }
        
        if game.status == .upcoming {
            game.status = .live
            game.date = Date() // Update date for sorting
            saveContext()
            print("🎮 Game STARTED: \(game.team1.name) vs \(game.team2.name)")
        }
    }
    
    /// Complete a game (live → completed)
    func completeGame(_ gameId: UUID) {
        guard let game = games.first(where: { $0.id == gameId }) else { return }
        
        if game.status == .live {
            game.status = .completed
            game.timeRemaining = "0:00:00"
            game.date = Date() // Update date for sorting
            saveContext()
            print("🏁 Game COMPLETED: \(game.team1.name) vs \(game.team2.name)")
        }
    }
    
    /// Reset a game (completed → upcoming)
    func resetGame(_ gameId: UUID) {
        guard let game = games.first(where: { $0.id == gameId }) else { return }
        
        if game.status == .completed {
            game.status = .upcoming
            game.timeRemaining = "1:00:00"
            game.team1.score = 0
            game.team2.score = 0
            game.date = Date() // Reset date for upcoming sorting
            
            // Reset player scores
            for playerScore in game.playerScores {
                playerScore.score = 0
            }
            
            saveContext()
            print("🔄 Game RESET: \(game.team1.name) vs \(game.team2.name)")
        }
    }
    
    // MARK: - Delete Game
    func deleteGame(_ gameId: UUID) {
        guard let gameToDelete = games.first(where: { $0.id == gameId }) else { return }
        
        modelContext.delete(gameToDelete)
        games.removeAll { $0.id == gameId }
        
        saveContext()
        print("🗑️ Game deleted")
    }
    
    // MARK: - Find Game by ID
    func findGame(by id: UUID) -> Game? {
        return games.first { $0.id == id }
    }
    
    // MARK: - Save Helper
    private func saveContext() {
        do {
            try modelContext.save()
            
            // Force UI update
            Task { @MainActor in
                await refreshData()
            }
            
        } catch {
            errorMessage = "Save failed: \(error.localizedDescription)"
            print("❌ Save error: \(error)")
        }
    }
    
    // MARK: - Statistics
    func getStats() -> (live: Int, upcoming: Int, completed: Int) {
        let liveCount = games.filter { $0.status == .live && !$0.shouldShowAsCompleted }.count
        let upcomingCount = games.filter { $0.status == .upcoming && !$0.shouldShowAsCompleted }.count
        let completedCount = games.filter { $0.shouldShowAsCompleted || $0.status == .completed }.count
        
        return (liveCount, upcomingCount, completedCount)
    }
}

// MARK: - MatchStatus Enum
enum MatchStatus: String, CaseIterable {
    case all = "All"
    case live = "Live"
    case upcoming = "Upcoming"
    case completed = "Completed"
}
