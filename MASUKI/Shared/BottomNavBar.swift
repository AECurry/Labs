//
//  BottomNavBar.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    @Environment(SessionManager.self) private var sessionManager
    var onTabTap: ((Int) -> Void)?
    
    @State private var showAlert = false
    @State private var pendingTab: Int? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            
            // Tab 1: Get Walking
            TabButton(
                iconName: "WalkingPerson",
                title: "Get Walking",
                isSelected: selectedTab == 0
            ) {
                handleTabTap(0)
            }
            
            Spacer()
                .frame(width: 32)
            
            // Tab 2: Progress
            TabButton(
                iconName: "Progress",
                title: "Progress",
                isSelected: selectedTab == 1
            ) {
                handleTabTap(1)
            }
            
            Spacer()
                .frame(width: 32)
            
            // Tab 3: More
            TabButton(
                iconName: "PineTree",
                title: "More",
                isSelected: selectedTab == 2
            ) {
                handleTabTap(2)
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(MasukiColors.adaptiveBackground)
        .padding(.bottom, 12)
        .alert("Leave Walking Session?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {
                pendingTab = nil
            }
            Button("Leave Session", role: .destructive) {
                if let tab = pendingTab {
                    // End the session first
                    sessionManager.endSession()
                    
                    // Then navigate
                    if let onTabTap = onTabTap {
                        onTabTap(tab)
                    } else {
                        selectedTab = tab
                    }
                }
                pendingTab = nil
            }
        } message: {
            Text("You're currently in a walking session. Are you sure you want to leave? Your progress will be lost.")
        }
    }
    
    private func handleTabTap(_ tab: Int) {
        // Check if a session is active
        if sessionManager.isSessionActive {
            pendingTab = tab
            showAlert = true
        } else {
            // No active session, navigate immediately
            if let onTabTap = onTabTap {
                onTabTap(tab)
            } else {
                selectedTab = tab
            }
        }
    }
    
    private func tabName(for tab: Int) -> String {
        switch tab {
        case 0: return "Get Walking"
        case 1: return "Progress"
        case 2: return "More"
        default: return "this tab"
        }
    }
}

// ADD THIS BACK - TabButton struct definition
struct TabButton: View {
    let iconName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private var isMoreTab: Bool {
        title == "More"
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Icon
                ZStack {
                    Image(iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected ?
                    MasukiColors.mediumJungle :
                    MasukiColors.coffeeBean)
                
                // Text with adjusted width
                Text(title)
                    .font(.custom("Inter-Medium", size: 12))
                    .foregroundColor(isSelected ?
                        MasukiColors.mediumJungle :
                        MasukiColors.coffeeBean)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(width: isMoreTab ? 60 : 72)
            }
            .frame(width: 72)
            .offset(x: isMoreTab ? -8 : 0)
        }
        .buttonStyle(.plain)
    }
}

// Preview
#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(0))
        BottomNavBar(selectedTab: .constant(1), onTabTap: { tab in
            print("Tab \(tab) tapped!")
        })
    }
    .background(MasukiColors.adaptiveBackground)
    .frame(height: 200)
}
