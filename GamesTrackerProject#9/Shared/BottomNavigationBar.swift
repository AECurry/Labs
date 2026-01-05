//
//  BottomNavigationBar.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/13/25.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: -32) {
            ForEach(0..<3) { index in  // Changed from 4 to 3
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: index))
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == index ? .fnWhite : .fnGray1)
                        
                        Text(label(for: index))
                            .font(.system(size: 12))
                            .foregroundColor(selectedTab == index ? .fnWhite : .fnGray2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 0)
                }
            }
        }
        .frame(height: 124)
        .background(
            Rectangle()
                // DARK PURPLE background to match animated grid
                .fill(Color(red: 0.08, green: 0.0, blue: 0.15).opacity(0.95))
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    private func iconName(for index: Int) -> String {
        switch index {
        case 0: return "trophy.fill"
        case 1: return "person.3.fill"
        case 2: return "chart.bar.fill"
        default: return "circle"
        }
    }
    
    private func label(for index: Int) -> String {
        switch index {
        case 0: return "Tournaments"
        case 1: return "Players"
        case 2: return "Ranking"
        default: return ""
        }
    }
}

#Preview {
    ZStack {
        AnimatedGridBackground()
        VStack {
            Spacer()
            BottomNavigationBar(selectedTab: .constant(0))
        }
    }
}

