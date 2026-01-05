//
//  RankingContentView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

struct RankingContentView: View {
    @ObservedObject var viewModel: RankingViewModel
    @Binding var showCelebration: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Show celebration for "Today" timeframe
                if viewModel.selectedTimeframe == .today &&
                   !viewModel.soloRankings.isEmpty &&
                   showCelebration {
                    CelebrationView(
                        winnerName: viewModel.soloRankings.first?.playerName ?? "Player 1",
                        winnerPoints: viewModel.soloRankings.first?.points ?? 950
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                }
                
                // Rankings list
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text(viewModel.currentTitle)
                        .font(.headline)
                        .foregroundColor(.fnWhite)
                        .padding(.horizontal)
                    
                    // Rankings Container
                    VStack(spacing: 0) {
                        rankingsContent
                    }
                    .background(Color.fnBlack.opacity(0.5))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.fnGray3.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
    }
    
    @ViewBuilder
    private var rankingsContent: some View {
        switch viewModel.selectedMode {
        case .solo:
            ForEach(Array(viewModel.soloRankings.enumerated()), id: \.element.id) { index, player in
                RankingRow(
                    rank: index + 1,
                    displayName: player.playerName,
                    subtitle: "\(player.wins) wins • \(Int(player.winRate * 100))% WR",
                    points: player.points
                )
                
                if index < viewModel.soloRankings.count - 1 {
                    Divider()
                        .background(Color.fnGray3.opacity(0.3))
                        .padding(.horizontal)
                }
            }
            
        case .duo:
            ForEach(Array(viewModel.duoRankings.enumerated()), id: \.element.id) { index, duo in
                RankingRow(
                    rank: index + 1,
                    displayName: duo.teamName,
                    subtitle: "\(duo.player1) & \(duo.player2)",
                    points: duo.points
                )
                
                if index < viewModel.duoRankings.count - 1 {
                    Divider()
                        .background(Color.fnSilver.opacity(0.3))
                        .padding(.horizontal)
                }
            }
            
        case .squad:
            ForEach(Array(viewModel.squadRankings.enumerated()), id: \.element.id) { index, squad in
                RankingRow(
                    rank: index + 1,
                    displayName: squad.squadName,
                    subtitle: "\(squad.players.count) players • \(squad.wins) wins",
                    points: squad.points
                )
                
                if index < viewModel.squadRankings.count - 1 {
                    Divider()
                        .background(Color.fnGray3.opacity(0.3))
                        .padding(.horizontal)
                }
            }
        }
    }
}
