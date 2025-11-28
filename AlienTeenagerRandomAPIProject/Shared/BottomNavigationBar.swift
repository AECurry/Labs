//
//  BottomNavigationBar.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/20/25.
//

import SwiftUI

struct BottomNavigationBar: View {
    @State private var selectedTab: Tab = .home
    @State private var discoverResetTrigger = false
    
    var body: some View {
        ZStack {
            TabContent(selectedTab: selectedTab, discoverResetTrigger: $discoverResetTrigger)
            
            VStack {
                Spacer()
                CustomTabBar(
                    selectedTab: $selectedTab,
                    onDiscoverTapped: {
                        discoverResetTrigger.toggle()
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Tab Management
extension BottomNavigationBar {
    enum Tab: CaseIterable {
        case home, discover, favorites, settings
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .discover: return "globe"
            case .favorites: return "heart"
            case .settings: return "gear"
            }
        }
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .discover: return "Discover"
            case .favorites: return "Favorites"
            case .settings: return "Settings"
            }
        }
    }
}

// MARK: - Tab Content
struct TabContent: View {
    let selectedTab: BottomNavigationBar.Tab
    @Binding var discoverResetTrigger: Bool
    
    var body: some View {
        switch selectedTab {
        case .discover:
            DiscoverScreenContainer(resetTrigger: discoverResetTrigger)
        case .home:
            HomeScreenView()
        case .favorites:
            PlaceholderView(title: "Favorites", icon: "heart")
        case .settings:
            PlaceholderView(title: "Settings", icon: "gear")
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: BottomNavigationBar.Tab
    let onDiscoverTapped: () -> Void
    
    private var style: TabBarStyle { .shared }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(BottomNavigationBar.Tab.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    style: style
                ) {
                    if tab == .discover && selectedTab == .discover {
                        onDiscoverTapped()
                    }
                    selectedTab = tab
                }
                
                if tab != .settings {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(height: style.pillHeight)
        .background(pillBackground)
    }
    
    private var pillBackground: some View {
        Capsule()
            .fill(style.pillBackgroundColor)
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 8)
    }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
    let tab: BottomNavigationBar.Tab
    let isSelected: Bool
    let style: TabBarStyle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: style.iconSize))
                    .foregroundStyle(iconColor)
                
                Text(tab.title)
                    .font(.system(size: style.textSize, weight: textWeight))
                    .foregroundStyle(textColor)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var iconColor: Color {
        isSelected ? style.selectedIconColor : style.unselectedIconColor
    }
    
    private var textColor: Color {
        isSelected ? style.selectedTextColor : style.unselectedTextColor
    }
    
    private var textWeight: Font.Weight {
        isSelected ? .semibold : .medium
    }
}

// MARK: - Styles
struct TabBarStyle {
    let pillBackgroundColor: Color = .deepNavy
    let pillHeight: CGFloat = 72
    
    let selectedIconColor: Color = .pumpkinSpice
    let unselectedIconColor: Color = .white
    
    let selectedTextColor: Color = .pumpkinSpice
    let unselectedTextColor: Color = .white
    
    let iconSize: CGFloat = 24
    let textSize: CGFloat = 12
    
    static let shared = TabBarStyle()
}

// MARK: - Placeholder View
struct PlaceholderView: View {
    let title: String
    let icon: String
    
    private var style: PlaceholderStyle { .shared }
    
    var body: some View {
        ZStack {
            style.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: style.contentSpacing) {
                Image(systemName: icon)
                    .font(.system(size: style.iconSize))
                    .foregroundStyle(style.iconColor)
                
                Text(title)
                    .font(style.titleFont)
                    .fontWeight(style.titleFontWeight)
                    .foregroundStyle(style.titleColor)
                
                Text(style.subtitleText)
                    .font(style.subtitleFont)
                    .foregroundStyle(style.subtitleColor.opacity(style.subtitleOpacity))
            }
        }
    }
}

struct PlaceholderStyle {
    let backgroundColor: Color = .deepNavy
    let iconSize: CGFloat = 60
    let iconColor: Color = .pumpkinSpice
    let titleFont: Font = .title
    let titleFontWeight: Font.Weight = .bold
    let titleColor: Color = .white
    let subtitleText: String = "Coming Soon"
    let subtitleFont: Font = .body
    let subtitleColor: Color = .white
    let subtitleOpacity: Double = 0.7
    let contentSpacing: CGFloat = 20
    
    static let shared = PlaceholderStyle()
}

// MARK: - Preview
#Preview {
    BottomNavigationBar()
}
