//
//  RankingData.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import Foundation

// MARK: - Mock Data Provider
struct RankingDataProvider {
    static func generateMockRankings() -> (solo: [PlayerRank], duo: [DuoTeamRank], squad: [SquadTeamRank]) {
        // Generate solo rankings
        let soloRankings = generateSoloRankings()
        
        // Generate duo rankings
        let duoRankings = generateDuoRankings()
        
        // Generate squad rankings
        let squadRankings = generateSquadRankings()
        
        return (soloRankings, duoRankings, squadRankings)
    }
    
    private static func generateSoloRankings() -> [PlayerRank] {
        var rankings: [PlayerRank] = []
        
        for index in 1...10 {
            let rank = PlayerRank(
                rank: index,
                playerName: "Player \(index)",
                points: 1000 - (index * 50),
                wins: 25 - (index * 2),
                winRate: max(0.3, 0.85 - (Double(index) * 0.05)),
                matchesPlayed: 100 - (index * 5),
                kills: 250 - (index * 20),
                averagePlacement: Double.random(in: 2.0...10.0)
            )
            rankings.append(rank)
        }
        
        return rankings
    }
    
    private static func generateDuoRankings() -> [DuoTeamRank] {
        var rankings: [DuoTeamRank] = []
        let teamNames = ["Alpha", "Beta", "Gamma", "Delta", "Echo"]
        
        for index in 1...10 {
            let rank = DuoTeamRank(
                rank: index,
                teamName: "Team \(teamNames[index % teamNames.count])",
                player1: "Player \(index * 2 - 1)",
                player2: "Player \(index * 2)",
                points: 2000 - (index * 100),
                wins: 20 - index,
                winRate: max(0.3, 0.80 - (Double(index) * 0.04))
            )
            rankings.append(rank)
        }
        
        return rankings
    }
    
    private static func generateSquadRankings() -> [SquadTeamRank] {
        var rankings: [SquadTeamRank] = []
        let squadNames = ["Wolf", "Eagle", "Bear", "Shark", "Lion"]
        
        for index in 1...10 {
            let players = (1...4).map { playerIndex in
                "Player \(index * 4 + playerIndex)"
            }
            
            let rank = SquadTeamRank(
                rank: index,
                squadName: "Squad \(squadNames[index % squadNames.count])",
                players: players,
                points: 4000 - (index * 200),
                wins: 15 - index,
                winRate: max(0.3, 0.75 - (Double(index) * 0.03))
            )
            rankings.append(rank)
        }
        
        return rankings
    }
}
