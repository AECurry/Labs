//
//  RankingHeaderView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

struct RankingHeaderView: View {
    @Binding var selectedTimeframe: RankingTimeframe
    @Binding var selectedMode: RankingMode
    
    var body: some View {
        VStack(spacing: 20) {
            TimeframeSelector(selectedTimeframe: $selectedTimeframe)
                .padding(.top, 8)
            
            ModeSelector(selectedMode: $selectedMode)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        .background(Color.fnBlack.opacity(0.7))
    }
}

struct TimeframeSelector: View {
    @Binding var selectedTimeframe: RankingTimeframe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Timeframe")
                .font(.caption)
                .foregroundColor(.fnGray1)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(RankingTimeframe.allCases, id: \.self) { timeframe in
                        TimeframePill(
                            timeframe: timeframe,
                            isSelected: timeframe == selectedTimeframe
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedTimeframe = timeframe
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ModeSelector: View {
    @Binding var selectedMode: RankingMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mode")
                .font(.caption)
                .foregroundColor(.fnGray1)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(RankingMode.allCases, id: \.self) { mode in
                        ModePill(
                            mode: mode,
                            isSelected: mode == selectedMode
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedMode = mode
                            }
                        }
                    }
                }
            }
        }
    }
}

