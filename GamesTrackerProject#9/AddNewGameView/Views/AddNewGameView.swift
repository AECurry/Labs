//
//  AddNewGameView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData

struct AddNewGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: AddGameViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background matching main app
                Color(red: 0.08, green: 0.0, blue: 0.15)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // GAME MODE SECTION
                        gameModeSection
                        
                        // PLAYER COUNT SECTION
                        playerCountSection
                        
                        // TEAM 1 SECTION
                        teamSection(teamNumber: 1)
                        
                        // TEAM 2 SECTION
                        teamSection(teamNumber: 2)
                        
                        // SCHEDULING SECTION
                        schedulingSection
                        
                        // CREATE BUTTON
                        createButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Create New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.fnWhite)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════
    // GAME MODE SECTION
    // ═══════════════════════════════════════════════════════════
    
    private var gameModeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Game Mode")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Picker("Game Mode", selection: $viewModel.gameSetup.gameMode) {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    HStack {
                        Image(systemName: mode.iconName)
                        Text(mode.rawValue)
                    }
                    .tag(mode)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.fnGray2)
            .cornerRadius(12)
        }
    }
    
    // ═══════════════════════════════════════════════════════════
    // PLAYER COUNT SECTION
    // ═══════════════════════════════════════════════════════════
    
    private var playerCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Players Per Team")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            HStack(spacing: 12) {
                ForEach(PlayerCount.allCases) { count in
                    Button {
                        viewModel.gameSetup.playerCount = count
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: count.icon)
                                .font(.title2)
                            Text(count.rawValue)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            viewModel.gameSetup.playerCount == count ?
                            Color.fnBlue : Color.fnGray2
                        )
                        .foregroundColor(
                            viewModel.gameSetup.playerCount == count ?
                            .fnWhite : .fnGray1
                        )
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════
    // TEAM SECTION (Reusable for Team 1 & 2)
    // ═══════════════════════════════════════════════════════════
    
    private func teamSection(teamNumber: Int) -> some View {
        let team = teamNumber == 1 ? viewModel.gameSetup.team1 : viewModel.gameSetup.team2
        let teamColor = team?.colorChoice ?? .fnBlue
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Team \(teamNumber)")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            // Team name input
            TextField("Team Name", text: binding(for: teamNumber, keyPath: \.name))
                .padding()
                .background(Color.fnGray2)
                .foregroundColor(.fnWhite)
                .cornerRadius(12)
            
            // Color picker
            HStack(spacing: 8) {
                Text("Color:")
                    .foregroundColor(.fnGray1)
                
                ForEach([Color.fnBlue, .fnRed, .fnGreen, .fnPurple, .fnGold], id: \.self) { color in
                    Button {
                        if teamNumber == 1 {
                            viewModel.gameSetup.team1?.colorChoice = color
                        } else {
                            viewModel.gameSetup.team2?.colorChoice = color
                        }
                    } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .strokeBorder(
                                        teamColor == color ? Color.fnWhite : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                    }
                }
            }
            .padding(.vertical, 8)
            
            // Student roster selector
            NavigationLink {
                StudentRosterView(
                    viewModel: viewModel,
                    teamNumber: teamNumber
                )
            } label: {
                HStack {
                    Text("Select Players")
                        .foregroundColor(.fnWhite)
                    Spacer()
                    Text("\(team?.selectedStudents.count ?? 0)/\(viewModel.gameSetup.playerCount.playerNumber)")
                        .foregroundColor(.fnGray1)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.fnGray1)
                }
                .padding()
                .background(Color.fnGray2)
                .cornerRadius(12)
            }
            
            // Selected students preview
            if let students = team?.selectedStudents, !students.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(students) { student in
                        HStack {
                            Circle()
                                .fill(teamColor)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(String(student.name.prefix(1)))
                                        .foregroundColor(.fnWhite)
                                        .font(.caption)
                                )
                            Text(student.name)
                                .foregroundColor(.fnWhite)
                            Spacer()
                            Button {
                                viewModel.removeStudentFromTeam(student, teamNumber: teamNumber)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.fnRed)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.fnGray2.opacity(0.5))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.fnBlack.opacity(0.3))
        .cornerRadius(16)
    }
    
    // ═══════════════════════════════════════════════════════════
    // SCHEDULING SECTION
    // ═══════════════════════════════════════════════════════════
    
    private var schedulingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Schedule")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Toggle("Schedule for later", isOn: $viewModel.gameSetup.isScheduled)
                .foregroundColor(.fnWhite)
                .padding()
                .background(Color.fnGray2)
                .cornerRadius(12)
            
            if viewModel.gameSetup.isScheduled {
                DatePicker(
                    "Game Time",
                    selection: $viewModel.gameSetup.scheduledTime,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .foregroundColor(.fnWhite)
                .padding()
                .background(Color.fnGray2)
                .cornerRadius(12)
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════
    // CREATE BUTTON
    // ═══════════════════════════════════════════════════════════
    
    private var createButton: some View {
        Button {
            if viewModel.validateAndSave() {
                dismiss()
            }
        } label: {
            Text("Create Game")
                .font(.headline)
                .foregroundColor(.fnWhite)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    viewModel.gameSetup.isValid ?
                    Color.fnBlue : Color.fnGray1
                )
                .cornerRadius(12)
        }
        .disabled(!viewModel.gameSetup.isValid)
        .padding(.top, 12)
    }
    
    // ═══════════════════════════════════════════════════════════
    // HELPER: Binding for team properties
    // ═══════════════════════════════════════════════════════════
    
    private func binding<T>(for teamNumber: Int, keyPath: WritableKeyPath<TeamSetup, T>) -> Binding<T> {
        Binding(
            get: {
                if teamNumber == 1 {
                    return viewModel.gameSetup.team1?[keyPath: keyPath] ?? TeamSetup()[keyPath: keyPath]
                } else {
                    return viewModel.gameSetup.team2?[keyPath: keyPath] ?? TeamSetup()[keyPath: keyPath]
                }
            },
            set: { newValue in
                if teamNumber == 1 {
                    viewModel.gameSetup.team1?[keyPath: keyPath] = newValue
                } else {
                    viewModel.gameSetup.team2?[keyPath: keyPath] = newValue
                }
            }
        )
    }
}

// ═══════════════════════════════════════════════════════════
// STUDENT ROSTER SELECTOR VIEW
// ═══════════════════════════════════════════════════════════

struct StudentRosterView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: AddGameViewModel
    let teamNumber: Int
    
    var body: some View {
        ZStack {
            Color(red: 0.08, green: 0.0, blue: 0.15)
                .ignoresSafeArea()
            
            List {
                ForEach(viewModel.availableStudents) { student in
                    Button {
                        toggleStudent(student)
                    } label: {
                        HStack {
                            // Student info
                            VStack(alignment: .leading) {
                                Text(student.name)
                                    .foregroundColor(.fnWhite)
                                Text("Grade \(student.grade) • \(student.skillLevel.rawValue)")
                                    .font(.caption)
                                    .foregroundColor(.fnGray1)
                            }
                            
                            Spacer()
                            
                            // Selection indicator
                            if viewModel.isStudentSelected(student) {
                                let team = viewModel.getTeamNumber(for: student)
                                if team == teamNumber {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.fnGreen)
                                } else {
                                    Text("Team \(team ?? 0)")
                                        .font(.caption)
                                        .foregroundColor(.fnGray1)
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color.fnGray2)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Select Players")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func toggleStudent(_ student: Student) {
        if let currentTeam = viewModel.getTeamNumber(for: student) {
            // Remove from current team
            viewModel.removeStudentFromTeam(student, teamNumber: currentTeam)
        } else {
            // Add to this team
            viewModel.addStudentToTeam(student, teamNumber: teamNumber)
        }
    }
}

// ═══════════════════════════════════════════════════════════
// PREVIEW
// ═══════════════════════════════════════════════════════════

#Preview {
    let container = try! ModelContainer(
        for: Game.self, Team.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let viewModel = AddGameViewModel(modelContext: container.mainContext)
    
    return AddNewGameView(viewModel: viewModel)
}
