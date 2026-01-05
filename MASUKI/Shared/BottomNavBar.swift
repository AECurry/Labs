//
//  BottomNavBar.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            
            // Tab 1: Get Walking
            TabButton(
                iconName: "WalkingPerson",
                title: "Get Walking",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            Spacer()
                .frame(width: 32)
            
            // Tab 2: Progress
            TabButton(
                iconName: "Progress",
                title: "Progress",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            Spacer()
                .frame(width: 32)
            
            // Tab 3: More
            TabButton(
                iconName: "PineTree",
                title: "More",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(MasukiColors.adaptiveBackground)
        .padding(.bottom, 12)
    }
}

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
            .offset(x: isMoreTab ? -8 : 0) // Shift entire content left
        }
        .buttonStyle(.plain)
    }
}

// Preview
#Preview {
    VStack {
        Spacer()
        BottomNavBar(selectedTab: .constant(0))
    }
    .background(MasukiColors.adaptiveBackground)
    .frame(height: 200)
}
