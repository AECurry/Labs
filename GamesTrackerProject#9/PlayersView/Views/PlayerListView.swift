//
//  PlayerListView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//  UPDATED: Fixed text visibility, added skill level badge
//

import SwiftUI
import SwiftData

struct PlayerListView: View {
    @Bindable var viewModel: PlayersViewModel
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            // Background layer
            AnimatedGridBackground()
                .ignoresSafeArea()
            
            // Content layer - explicitly on top
            VStack(spacing: 0) {
                searchBar
                
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.filteredStudents.isEmpty {
                    emptyStateView
                } else {
                    playersList
                }
            }
            .zIndex(1) // Ensure content is above background
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .medium))
            
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("Search players...")
                        .foregroundStyle(.white.opacity(0.5))
                }
                TextField("", text: $viewModel.searchText)
                    .foregroundStyle(.white)
                    .tint(.white)
                    .autocorrectionDisabled()
            }
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.15))
        )
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: viewModel.searchText.isEmpty ? "person.3.fill" : "person.slash")
                .font(.system(size: 60))
                .foregroundColor(.fnGray1)
            
            Text(viewModel.searchText.isEmpty ? "No Players" : "No Results")
                .font(.title2)
                .foregroundColor(.fnWhite)
                .fontWeight(.semibold)
            
            Text(viewModel.searchText.isEmpty ?
                 "Add your first player!" :
                 "No players found for \"\(viewModel.searchText)\"")
                .font(.body)
                .foregroundColor(.fnGray1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var playersList: some View {
        List {
            ForEach(viewModel.filteredStudents) { student in
                HStack(spacing: 16) {
                    // Avatar Circle
                    ZStack {
                        Circle()
                            .fill(student.skillLevel.color)
                            .frame(width: 50, height: 50)
                        
                        Text(student.initial)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.fnWhite)
                    }
                    
                    // Player Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(student.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.white)
                        
                        Text("Grade \(student.grade)")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Skill Level Badge
                    HStack(spacing: 4) {
                        Image(systemName: student.skillLevel.icon)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(student.skillLevel.rawValue)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(student.skillLevel.color.opacity(0.9))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(student.skillLevel.color, lineWidth: 1.5)
                    )
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.vertical, 8)
            }
            .onDelete(perform: viewModel.deleteStudents)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Student.self, configurations: config)
    
    let viewModel = PlayersViewModel(modelContext: container.mainContext)
    
    let testStudents = [
        Student(name: "Alex Johnson", grade: 11, skillLevel: .pro, studentID: "AJ001"),
        Student(name: "Jordan Lee", grade: 9, skillLevel: .beginner, studentID: "JL002"),
        Student(name: "Maria Garcia", grade: 10, skillLevel: .advanced, studentID: "MG003"),
        Student(name: "Nick Cartwright", grade: 12, skillLevel: .advanced, studentID: "NC004"),
        Student(name: "Sam Sowell", grade: 9, skillLevel: .intermediate, studentID: "SS005"),
        Student(name: "Taylor Smith", grade: 12, skillLevel: .intermediate, studentID: "TS006")
    ]
    
    for student in testStudents {
        container.mainContext.insert(student)
    }
    
    try? container.mainContext.save()
    viewModel.loadStudents()
    
    return PlayerListView(viewModel: viewModel)
}
