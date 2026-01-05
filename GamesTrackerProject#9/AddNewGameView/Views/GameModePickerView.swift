//
//  GameModePickerView.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

struct GameModePickerView: View {
    @Binding var selectedMode: GameMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Game Mode")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Menu {
                ForEach(GameMode.allCases, id: \.self) { mode in
                    Button {
                        selectedMode = mode
                    } label: {
                        HStack {
                            Image(systemName: mode.iconName)
                            Text(mode.rawValue)
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: selectedMode.iconName)
                        .foregroundColor(.fnGold)
                    Text(selectedMode.rawValue)
                        .foregroundColor(.fnWhite)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundColor(.fnGray1)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.fnGray2)
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        GameModePickerView(selectedMode: .constant(.battleRoyale))
            .padding()
    }
}
