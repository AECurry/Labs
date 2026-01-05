//
//  TeamConfigurationView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI
import SwiftData

struct TeamConfigurationView: View {
    let teamNumber: Int
    @Binding var teamName: String
    @Binding var teamColor: Color
    @Binding var selectedPlayers: [Student]
    @Binding var showSelection: Bool
    
    let requiredPlayerCount: Int
    let onRemovePlayer: (Student) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Team \(teamNumber)")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            // Team name input
            TextField("Team Name", text: $teamName)
                .padding()
                .background(Color.fnGray2)
                .foregroundColor(.fnWhite)
                .cornerRadius(12)
            
            // Color picker
            TeamColorPicker(selectedColor: $teamColor)
            
            // Player selection button
            Button {
                showSelection = true
            } label: {
                HStack {
                    Text("Select Players")
                        .foregroundColor(.fnWhite)
                    Spacer()
                    Text("\(selectedPlayers.count)/\(requiredPlayerCount)")
                        .foregroundColor(selectedPlayers.count == requiredPlayerCount ? .fnGreen : .fnGray1)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.fnGray1)
                }
                .padding()
                .background(Color.fnGray2)
                .cornerRadius(12)
            }
            
            // Selected players preview
            if !selectedPlayers.isEmpty {
                SelectedPlayersPreview(
                    players: selectedPlayers,
                    teamColor: teamColor,
                    onRemove: onRemovePlayer
                )
            }
        }
        .padding()
        .background(Color.fnBlack.opacity(0.3))
        .cornerRadius(16)
    }
}

// MARK: - Team Color Picker Component

struct TeamColorPicker: View {
    @Binding var selectedColor: Color
    
    private let availableColors: [Color] = [.fnBlue, .fnRed, .fnGreen, .fnPurple, .fnGold]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color:")
                .font(.subheadline)
                .foregroundColor(.fnGray1)
            
            HStack(spacing: 12) {
                ForEach(availableColors, id: \.self) { color in
                    Button {
                        selectedColor = color
                    } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .strokeBorder(
                                        selectedColor == color ? Color.fnWhite : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Selected Players Preview Component

struct SelectedPlayersPreview: View {
    let players: [Student]
    let teamColor: Color
    let onRemove: (Student) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(players) { student in
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
                        onRemove(student)
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

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        TeamConfigurationView(
            teamNumber: 1,
            teamName: .constant("Team Alpha"),
            teamColor: .constant(.fnBlue),
            selectedPlayers: .constant([]),
            showSelection: .constant(false),
            requiredPlayerCount: 2,
            onRemovePlayer: { _ in }
        )
        .padding()
    }
}
