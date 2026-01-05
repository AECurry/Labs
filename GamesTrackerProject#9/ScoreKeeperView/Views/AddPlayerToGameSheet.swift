//
//  AddPlayerToGameSheet.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

import SwiftUI
import SwiftData

struct AddPlayerToGameSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Student.name) private var allStudents: [Student]
    
    let game: Game
    let onAddPlayer: (Student, Int) -> Void
    
    @State private var selectedTeam: Int = 1
    @State private var searchText = ""
    
    private var availableStudents: [Student] {
        let existingPlayerIds = Set(game.playerScores.map { $0.student.id })
        let filtered = allStudents.filter { !existingPlayerIds.contains($0.id) && $0.isActive }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { student in
                student.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Team Selector
                    teamSelector
                    
                    // Search Bar
                    searchBar
                    
                    // Players List
                    if availableStudents.isEmpty {
                        emptyStateView
                    } else {
                        playersList
                    }
                }
            }
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.fnWhite)
                }
            }
        }
    }
    
    // MARK: - Team Selector
    
    private var teamSelector: some View {
        HStack(spacing: 16) {
            // Team 1 Button
            Button {
                selectedTeam = 1
            } label: {
                VStack(spacing: 8) {
                    Circle()
                        .fill(game.team1.logoColor)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(game.team1.name.prefix(2).uppercased()))
                                .font(.caption)
                                .foregroundColor(.fnWhite)
                        )
                    
                    Text(game.team1.name)
                        .font(.subheadline)
                        .foregroundColor(.fnWhite)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    selectedTeam == 1 ?
                    game.team1.logoColor.opacity(0.3) : Color.fnGray2.opacity(0.3)
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            selectedTeam == 1 ? game.team1.logoColor : Color.clear,
                            lineWidth: 2
                        )
                )
            }
            
            // Team 2 Button
            Button {
                selectedTeam = 2
            } label: {
                VStack(spacing: 8) {
                    Circle()
                        .fill(game.team2.logoColor)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(game.team2.name.prefix(2).uppercased()))
                                .font(.caption)
                                .foregroundColor(.fnWhite)
                        )
                    
                    Text(game.team2.name)
                        .font(.subheadline)
                        .foregroundColor(.fnWhite)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    selectedTeam == 2 ?
                    game.team2.logoColor.opacity(0.3) : Color.fnGray2.opacity(0.3)
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            selectedTeam == 2 ? game.team2.logoColor : Color.clear,
                            lineWidth: 2
                        )
                )
            }
        }
        .padding()
        .background(Color.fnBlack.opacity(0.3))
        
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.fnGray1)
            
            TextField("Search players...", text: $searchText)
                .foregroundColor(.fnWhite)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.fnGray1)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.fnGray3.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
    
    // MARK: - Players List
    
    private var playersList: some View {
        List {
            ForEach(availableStudents) { student in
                Button {
                    addPlayerToGame(student)
                } label: {
                    HStack(spacing: 16) {
                        // Avatar
                        Circle()
                            .fill(student.skillLevel.color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Text(student.initial)
                                    .font(.headline)
                                    .foregroundColor(.fnWhite)
                            )
                        // Student Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(student.name)
                                .font(.headline)
                                .foregroundColor(.fnWhite)
                            
                            HStack(spacing: 8) {
                                Text("Grade \(student.grade)")
                                    .font(.caption)
                                    .foregroundColor(.fnGray1)
                                
                                Text("•")
                                    .foregroundColor(.fnGray1)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: student.skillLevel.icon)
                                        .font(.caption2)
                                    Text(student.skillLevel.rawValue)
                                        .font(.caption)
                                }
                                .foregroundColor(student.skillLevel.color)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.fnBlue)
                            .font(.title3)
                    }
                }
                .listRowBackground(Color.fnGray2.opacity(0.5))
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: searchText.isEmpty ? "person.3.fill" : "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.fnGray1)
            
            Text(searchText.isEmpty ? "All Players Added" : "No Results")
                .font(.title2)
                .foregroundColor(.fnWhite)
            
            Text(searchText.isEmpty ?
                 "All available players are already in this game" :
                    "No players found matching \"\(searchText)\"")
            .font(.body)
            .foregroundColor(.fnGray1)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    // MARK: - Actions
    
    private func addPlayerToGame(_ student: Student) {
        onAddPlayer(student, selectedTeam)
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Game.self, Team.self, Student.self, PlayerScore.self,
        configurations: config
    )
    
    let context = container.mainContext
    
    let team1 = Team(name: "Team Alpha", colorAssetName: "FortniteBlue")
    let team2 = Team(name: "Team Bravo", colorAssetName: "FortniteRed")
    
    let game = Game(
        date: Date(),
        timeRemaining: "0:15:00",
        status: .live,
        team1: team1,
        team2: team2,
        gameMode: .battleRoyale
    )
    
    context.insert(team1)
    context.insert(team2)
    context.insert(game)
    
    Student.seedPreviewData(into: context)
    
    try? context.save()
    
    return AddPlayerToGameSheet(
        game: game,
        onAddPlayer: { _, _ in }
    )
    .modelContainer(container)
}
