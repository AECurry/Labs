//
//  RiderListView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct RiderListView: View {
    @Environment(RiderRouter.self) private var router
    @Environment(RiderDataService.self) private var riderService
    @Environment(MainRouter.self) private var mainRouter
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        ZStack {
            themeBackground.backgroundView()
            
            VStack(spacing: 0) {
                // Custom title bar - NO BACKGROUND like DragonListView
                HStack {
                    Text("Riders")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white) // White text on dark background
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(riderService.riders) { rider in
                            RiderCardView(rider: rider)
                                .onTapGesture {
                                    router.navigateToDetail(rider)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RiderListView()
            .environment(RiderRouter(riderService: RiderDataService()))
            .environment(RiderDataService())
            .environment(MainRouter())
            .environment(ThemeBackground())
    }
}
