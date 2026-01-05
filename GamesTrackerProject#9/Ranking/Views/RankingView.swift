//
//  RankingView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/18/25.
//

import SwiftUI

struct RankingView: View {
    @StateObject private var viewModel = RankingViewModel()
    @State private var showCelebration = false
    
    var body: some View {
        ZStack {
            // Animated Background
            AnimatedGridBackground()
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                RankingHeaderView(
                    selectedTimeframe: $viewModel.selectedTimeframe,
                    selectedMode: $viewModel.selectedMode
                )
                
                if viewModel.isLoading {
                    loadingView
                } else {
                    RankingContentView(
                        viewModel: viewModel,
                        showCelebration: $showCelebration
                    )
                }
            }
        }
        .navigationTitle("Ranking")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            // Optional: Add custom title styling
            ToolbarItem(placement: .principal) {
                Text("Ranking")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.fnWhite)
            }
        }
        .onAppear {
            viewModel.loadRankings()
            
            // Trigger celebration animation after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if viewModel.selectedTimeframe == .today {
                    showCelebration = true
                    
                    // Auto-hide celebration after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showCelebration = false
                        }
                    }
                }
            }
        }
        // FIXED: Modern onChange syntax
        .onChange(of: viewModel.selectedTimeframe) { oldValue, newValue in
            // Show/hide celebration based on timeframe
            withAnimation {
                showCelebration = (newValue == .today)
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .tint(.fnWhite)
                .scaleEffect(1.5)
            
            Text("Loading rankings...")
                .font(.headline)
                .foregroundColor(.fnWhite)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        Color.fnBlack.ignoresSafeArea()
        
        RankingView()
            .background(Color.clear)
    }
    .preferredColorScheme(.dark)
}
