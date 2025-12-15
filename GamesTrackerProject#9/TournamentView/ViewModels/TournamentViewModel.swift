//
//  TournamentViewModel.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class TournamentViewModel {
    // MARK: - Published Properties
    var matches: [TournamentMatch] = []
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Computed Properties
    var liveMatchesCount: Int {
        matches.filter { $0.isLive }.count
    }
    
    var completedMatchesCount: Int {
        matches.filter { !$0.isLive && $0.team1Score + $0.team2Score > 0 }.count
    }
    
    var upcomingMatchesCount: Int {
        matches.filter { !$0.isLive && $0.team1Score + $0.team2Score == 0 }.count
    }
    
    // MARK: - Dependencies
    private var modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Data Loading
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay for realistic UX
        try? await Task.sleep(for: .milliseconds(300))
        
        await MainActor.run {
            fetchGamesFromSwiftData()
            
            // If no persisted data, load sample data
            if matches.isEmpty {
                loadSampleData()
            }
            
            isLoading = false
        }
    }
    
    func refreshData() async {
        await loadData()
    }
    
    // MARK: - SwiftData Operations
    private func fetchGamesFromSwiftData() {
        do {
            let descriptor = FetchDescriptor<Game>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            
            let games = try modelContext.fetch(descriptor)
            
            // Convert SwiftData models to display models
            matches = games.enumerated().map { index, game in
                TournamentMatch(
                    id: game.id,
                    team1Name: game.team1.name,
                    team1Score: game.team1.score,
                    team1Initials: String(game.team1.name.prefix(2).uppercased()),
                    team1Color: game.team1.logoColor,
                    team2Name: game.team2.name,
                    team2Score: game.team2.score,
                    team2Initials: String(game.team2.name.prefix(2).uppercased()),
                    team2Color: game.team2.logoColor,
                    timeRemaining: game.timeRemaining,
                    isLive: game.status == .live,
                    matchNumber: index + 1,
                    gameMode: game.gameModeEnum
                )
            }
            
        } catch {
            errorMessage = "Failed to load games: \(error.localizedDescription)"
            print("❌ Fetch error: \(error)")
        }
    }
    
    private func loadSampleData() {
        matches = TournamentMatch.sampleTournament
        print("✅ Loaded \(matches.count) sample matches")
    }
    
    // MARK: - CRUD Operations
    
    /// Deletes a match from the view model (UI only - persistence handled by view)
    func deleteMatch(_ match: TournamentMatch) {
        matches.removeAll { $0.id == match.id }
    }
    
    func addNewGame(
        team1Name: String,
        team1Color: Color,
        team2Name: String,
        team2Color: Color,
        gameMode: GameMode = .battleRoyale,
        isLive: Bool = false
    ) {
        // Create teams
        let team1 = Team(name: team1Name, colorAssetName: team1Color.description)
        let team2 = Team(name: team2Name, colorAssetName: team2Color.description)
        
        // Create game
        let game = Game(
            date: Date(),
            timeRemaining: isLive ? "0:15:00" : "0:00:00",
            status: isLive ? .live : .upcoming,
            team1: team1,
            team2: team2,
            gameMode: gameMode
        )
        
        // Insert into SwiftData
        modelContext.insert(game)
        
        // Save context
        saveContext()
        
        // Reload UI
        fetchGamesFromSwiftData()
    }
    
    func deleteGame(at indexSet: IndexSet) {
        for index in indexSet {
            let matchToDelete = matches[index]
            let matchId = matchToDelete.id
            
            // Find and delete from SwiftData
            do {
                let descriptor = FetchDescriptor<Game>(
                    predicate: #Predicate<Game> { game in
                        game.id == matchId
                    }
                )
                
                if let gameToDelete = try modelContext.fetch(descriptor).first {
                    modelContext.delete(gameToDelete)
                    saveContext()
                }
            } catch {
                errorMessage = "Failed to delete game: \(error.localizedDescription)"
                print("❌ Delete error: \(error)")
            }
        }
        
        // Reload UI
        fetchGamesFromSwiftData()
    }
    
    func updateScore(for matchId: UUID, team1Score: Int, team2Score: Int) {
        do {
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate<Game> { game in
                    game.id == matchId
                }
            )
            
            if let game = try modelContext.fetch(descriptor).first {
                game.team1.score = team1Score
                game.team2.score = team2Score
                saveContext()
                fetchGamesFromSwiftData()
            }
        } catch {
            errorMessage = "Failed to update score: \(error.localizedDescription)"
            print("❌ Update error: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
            print("✅ Context saved successfully")
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            print("❌ Save error: \(error)")
        }
    }
    
    // MARK: - Filtering & Sorting
    func filterLiveMatches() -> [TournamentMatch] {
        matches.filter { $0.isLive }
    }
    
    func filterCompletedMatches() -> [TournamentMatch] {
        matches.filter { !$0.isLive && $0.team1Score + $0.team2Score > 0 }
    }
    
    func filterUpcomingMatches() -> [TournamentMatch] {
        matches.filter { !$0.isLive && $0.team1Score + $0.team2Score == 0 }
    }
}
