//
//  RankingViewModel.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI
import Combine

final class RankingViewModel: ObservableObject {
    @Published var selectedTimeframe: RankingTimeframe = .today  // CHANGED: Default to Today
    @Published var selectedMode: RankingMode = .solo
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    // Data
    private(set) var soloRankings: [PlayerRank] = []
    private(set) var duoRankings: [DuoTeamRank] = []
    private(set) var squadRankings: [SquadTeamRank] = []
    
    private let rankingService: RankingServiceProtocol
    
    init(rankingService: RankingServiceProtocol = MockRankingService()) {
        self.rankingService = rankingService
        loadRankings()
    }
    
    func loadRankings() {
        isLoading = true
        errorMessage = nil
        
        // In production, this would be an async network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let data = RankingDataProvider.generateMockRankings()
            self.soloRankings = data.solo
            self.duoRankings = data.duo
            self.squadRankings = data.squad
            self.isLoading = false
        }
    }
    
    var currentTitle: String {
        switch selectedMode {
        case .solo: return "Top Solo Players"
        case .duo: return "Top Duo Teams"
        case .squad: return "Top Squad Teams"
        }
    }
}

// MARK: - Protocols for Dependency Injection
protocol RankingServiceProtocol {
    func fetchRankings() async throws -> (solo: [PlayerRank], duo: [DuoTeamRank], squad: [SquadTeamRank])
}

struct MockRankingService: RankingServiceProtocol {
    func fetchRankings() async throws -> (solo: [PlayerRank], duo: [DuoTeamRank], squad: [SquadTeamRank]) {
        return RankingDataProvider.generateMockRankings()
    }
}
