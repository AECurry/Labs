//
//  TitleAndSegmentedView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/11/25.
//

import SwiftUI
import SwiftData

struct TitleAndSegmentedView: View {
    @Bindable var viewModel: TournamentViewModel
    let modelContext: ModelContext
    
    @State private var selectedStatus: MatchStatus = .all
    @State private var showingCreateGame = false
    
    var filteredMatches: [TournamentMatch] {
        switch selectedStatus {
        case .all:
            return viewModel.matches
        case .live:
            return viewModel.matches.filter { $0.isLive }
        case .upcoming:
            return viewModel.matches.filter { !$0.isLive && $0.team1Score == 0 }
        case .completed:
            return viewModel.matches.filter { !$0.isLive && $0.team1Score > 0 }
        }
    }
    
    var body: some View {
        // REMOVED NavigationStack - it adds opaque backgrounds
        ScrollView {
            VStack(spacing: 0) {
                // Custom Navigation Bar
                customNavigationBar
                
                // Segmented Control and Content
                VStack(spacing: 20) {
                    segmentedControl
                    contentSection
                }
            }
            .padding(.top, 10)
        }
        .scrollContentBackground(.hidden) // Make ScrollView transparent
        .background(Color.clear) // Transparent background
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .sheet(isPresented: $showingCreateGame) {
            createGameSheet
        }
    }
    
    // MARK: - Custom Navigation Bar
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
    
    // MARK: - Segmented Control
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
            // Customize segmented control appearance
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
    
    // MARK: - Content Section
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
        } else if filteredMatches.isEmpty {
            EmptyStateView(status: selectedStatus)
                .padding(.top, 40)
        } else {
            matchesList
        }
    }
    
    // MARK: - Matches List with Swipe-to-Delete
    private var matchesList: some View {
        VStack(spacing: 16) {
            ForEach(filteredMatches) { match in
                SwipeToDeleteCard(
                    match: match,
                    onDelete: { handleDelete(match) }
                ) {
                    TournamentCard(match: match)
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - Delete Handler
    private func handleDelete(_ match: TournamentMatch) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            viewModel.deleteMatch(match)
        }
        deleteFromPersistence(match)
    }
    
    private func deleteFromPersistence(_ match: TournamentMatch) {
        let matchId = match.id
        
        do {
            let descriptor = FetchDescriptor<Game>(
                predicate: #Predicate<Game> { game in
                    game.id == matchId
                }
            )
            
            if let gameToDelete = try modelContext.fetch(descriptor).first {
                modelContext.delete(gameToDelete)
                try modelContext.save()
                print("Deleted from SwiftData")
            }
        } catch {
            print("SwiftData deletion error: \(error)")
        }
    }
    
    // MARK: - Create Game Sheet
    private var createGameSheet: some View {
        let addGameViewModel = AddGameViewModel(modelContext: modelContext)
        
        return AddNewGameView(viewModel: addGameViewModel)
            .onDisappear {
                // Reload games when sheet closes
                Task {
                    await viewModel.loadData()
                }
            }
    }
}

// MARK: - Match Status Enum
enum MatchStatus: String, CaseIterable {
    case all = "All"
    case live = "Live"
    case upcoming = "Upcoming"
    case completed = "Completed"
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.fnGray2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let status: MatchStatus
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconForStatus)
                .font(.largeTitle)
                .foregroundColor(.fnGray2)
            
            Text(messageForStatus)
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Text(subtitleForStatus)
                .font(.caption)
                .foregroundColor(.fnGray2)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var iconForStatus: String {
        switch status {
        case .all: return "trophy"
        case .live: return "livephoto"
        case .upcoming: return "clock"
        case .completed: return "checkmark.circle"
        }
    }
    
    private var messageForStatus: String {
        switch status {
        case .all: return "No matches yet"
        case .live: return "No live matches"
        case .upcoming: return "No upcoming matches"
        case .completed: return "No completed matches"
        }
    }
    
    private var subtitleForStatus: String {
        switch status {
        case .all: return "Tap the + button to create your first game!"
        case .live: return "Check back later for live action"
        case .upcoming: return "Upcoming matches will appear here"
        case .completed: return "Completed matches will appear here"
        }
    }
}

// MARK: - Preview
#Preview {
    let container = try! ModelContainer(
        for: Game.self, Team.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    let viewModel = TournamentViewModel(modelContext: context)
    
    return ZStack {
        AnimatedGridBackground()
        TitleAndSegmentedView(viewModel: viewModel, modelContext: context)
    }
}
