//
//  TitleAndSegmentedView.swift
//  GamesTrackerProject#9
//

import SwiftUI
import SwiftData

struct TitleAndSegmentedView: View {
    @Bindable var viewModel: TournamentViewModel
    let modelContext: ModelContext
    
    @State private var selectedStatus: MatchStatus = .all
    @State private var showingCreateGame = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                customNavigationBar
                
                VStack(spacing: 20) {
                    segmentedControl
                    contentSection
                }
            }
            .padding(.top, 10)
        }
        .scrollContentBackground(.hidden)
        .background(AnimatedGridBackground())
        .navigationDestination(for: UUID.self) { gameId in
            ScoreKeeperView(gameId: gameId)
        }
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .sheet(isPresented: $showingCreateGame) {
            AddNewGameView()
                .onDisappear {
                    Task {
                        await viewModel.refreshData()
                    }
                }
        }
    }
    
    private var customNavigationBar: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showingCreateGame = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.fnWhite)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.fnBlack.opacity(0.5)))
                }
                .padding(.trailing, 16)
                .padding(.top, 12)
                .accessibilityLabel("Create new game")
            }
            .frame(height: 56)
            
            Text("Tournaments")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.fnWhite)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)
                .padding(.bottom, 20)
        }
    }
    
    private var segmentedControl: some View {
        Picker("Match Status", selection: $selectedStatus) {
            ForEach(MatchStatus.allCases, id: \.self) { status in
                Text(status.rawValue)
                    .tag(status)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .padding(.top, 4)
        .onAppear {
            let appearance = UISegmentedControl.appearance()
            appearance.selectedSegmentTintColor = UIColor(Color.fnWhite)
            appearance.setTitleTextAttributes(
                [.foregroundColor: UIColor(Color.fnBlack)],
                for: .selected
            )
            appearance.setTitleTextAttributes(
                [.foregroundColor: UIColor(Color.fnWhite)],
                for: .normal
            )
            appearance.backgroundColor = UIColor(Color.fnBlack.opacity(0.3))
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            ProgressView("Loading matches...")
                .foregroundColor(.fnWhite)
                .padding()
                .padding(.top, 20)
            
        } else if let error = viewModel.errorMessage {
            ErrorView(message: error)
                .padding(.top, 20)
            
        } else if viewModel.matches(for: selectedStatus).isEmpty {
            EmptyStateView(status: selectedStatus)
                .padding(.top, 40)
            
        } else {
            matchesList
        }
    }
    
    // MARK: - Updated matchesList Property
    private var matchesList: some View {
        VStack(spacing: 16) {
            // When showing "All", group by status with section headers
            if selectedStatus == .all {
                // Get matches for each status
                let liveMatches = viewModel.matches(for: .live)
                let upcomingMatches = viewModel.matches(for: .upcoming)
                let completedMatches = viewModel.matches(for: .completed)
                
                VStack(spacing: 24) {
                    // Live Matches Section
                    if !liveMatches.isEmpty {
                        HStack {
                            Text("🔥 LIVE MATCHES")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.fnWhite)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        ForEach(liveMatches) { match in
                            matchCard(match)
                        }
                    }
                    
                    // Upcoming Matches Section
                    if !upcomingMatches.isEmpty {
                        HStack {
                            Text("⏰ UPCOMING MATCHES")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.fnWhite)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        ForEach(upcomingMatches) { match in
                            matchCard(match)
                        }
                    }
                    
                    // Completed Matches Section
                    if !completedMatches.isEmpty {
                        HStack {
                            Text("✅ COMPLETED MATCHES")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.fnWhite)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        ForEach(completedMatches) { match in
                            matchCard(match)
                        }
                    }
                }
            } else {
                // When filtered by specific status, show simple list
                ForEach(viewModel.matches(for: selectedStatus)) { match in
                    matchCard(match)
                }
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - Individual Match Card
    private func matchCard(_ match: TournamentMatch) -> some View {
        NavigationLink(value: match.id) {
            SwipeToDeleteCard(
                match: match,
                onDelete: { handleDelete(match) }
            ) {
                TournamentCard(match: match)
                    .environment(viewModel)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .contextMenu {
            // Quick actions menu
            if match.isLive {
                Button("Mark as Completed") {
                    viewModel.completeGame(match.id)
                }
            } else if !match.hasScores {
                Button("Start Game") {
                    viewModel.startGame(match.id)
                }
            } else if match.hasScores && !match.isLive {
                Button("Reset Game") {
                    viewModel.resetGame(match.id)
                }
            }
            
            Divider()
            
            Button("Delete Match", role: .destructive) {
                handleDelete(match)
            }
            .disabled(match.isLive)
        }
    }
    
    // MARK: - Delete Handler
    private func handleDelete(_ match: TournamentMatch) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.deleteGame(match.id)
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Game.self, Team.self, Student.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    let viewModel = TournamentViewModel(modelContext: context)
    
    return TitleAndSegmentedView(viewModel: viewModel, modelContext: context)
}
