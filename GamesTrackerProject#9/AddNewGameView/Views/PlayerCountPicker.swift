//
//  PlayerCountPicker.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

struct PlayerCountPickerView: View {
    @Binding var selectedCount: PlayerCount
    var onCountChange: ((PlayerCount) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Players Per Team")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            HStack(spacing: 12) {
                ForEach(PlayerCount.allCases) { count in
                    Button {
                        selectedCount = count
                        onCountChange?(count)
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
                            selectedCount == count ?
                            Color.fnBlue : Color.fnGray2
                        )
                        .foregroundColor(
                            selectedCount == count ?
                            .fnWhite : .fnGray1
                        )
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        PlayerCountPickerView(selectedCount: .constant(.duo))
            .padding()
    }
}
