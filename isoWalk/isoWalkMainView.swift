//
//  isoWalkMainView.swift
//  isoWalk
//
//  Created by AnnElaine on 2/17/26.
//

//  Main parent file for the entire app
import SwiftUI

struct isoWalkMainView: View {
    @State private var selectedTab: Int = 0
    @State private var showNavBar: Bool = true
    @Environment(SessionManager.self) private var sessionManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                GetWalkingView()
                    .tag(0)
                
                ProgressScreenView()
                    .tag(1)
                
                Text("Features Screen")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            if showNavBar {
                BottomNavBar(selectedTab: $selectedTab)
                    .padding(.bottom, 0)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    isoWalkMainView()
        .environment(SessionManager())
}
