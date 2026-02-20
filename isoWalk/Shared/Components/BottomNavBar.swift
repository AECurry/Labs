//
//  BottomNavBar.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 56) {
            TabBarItem(icon: "figure.walk", title: "Walk", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabBarItem(icon: "trophy.fill", title: "Progress", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            TabBarItem(icon: "person.fill", title: "Features", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.clear)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    if isSelected {
                        // Gradient circle with 3D depth
                        Circle()
                            .fill(isoWalkColors.gradientBlue)
                            .shadow(color: isoWalkColors.deepSpaceBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.0)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(isSelected ? .white : isoWalkColors.deepSpaceBlue)
                }
                .frame(width: 56, height: 56)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isoWalkColors.jetBlack) // jetBlack for all tab text
            }
        }
        .buttonStyle(.plain)
    }
}

