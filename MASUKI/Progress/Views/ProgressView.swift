//
//  ProgressView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

//  Main parent file for the progress folder
import SwiftUI

struct ProgressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel = ProgressViewModel()
    
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // 1. HEADER
                    ProgressHeader()
                    
                    // 2. TITLE
                    ProgressTitle(totalMiles: viewModel.totalMiles)
                    
                    // 3. TODAY'S PROGRESS & STREAK
                    VStack(spacing: 16) {
                        TodayProgressCard(miles: viewModel.todayMiles)
                        StreakCard(
                            currentStreak: viewModel.currentStreak,
                            longestStreak: viewModel.longestStreak
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                    
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.loadData()
        }
    }
}

#Preview {
    ProgressView()
}
