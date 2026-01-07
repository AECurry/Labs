//
//  MasukiMainView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

//  Main parent file for the whole app
import SwiftUI

struct MasukiMainView: View {
    @State private var selectedTab = 0
    @State private var sessionManager = SessionManager.shared
    
    var body: some View {
        ZStack {
            // Your main content
            Group {
                switch selectedTab {
                case 0:
                    GetWalkingView()
                case 1:
                    ProgressView()
                case 2:
                    MoreView()
                default:
                    GetWalkingView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Navigation bar at the bottom
            VStack {
                Spacer()
                BottomNavBar(
                    selectedTab: $selectedTab,
                    sessionManager: sessionManager
                )
            }
        }
        .environment(sessionManager)
    }
}

#Preview {
    MasukiMainView()
}
