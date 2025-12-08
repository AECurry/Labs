//
//  DragonListView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

struct DragonListView: View {
    @Environment(DragonRouter.self) private var router
    @Environment(DragonDataService.self) private var dragonService
    @Environment(MainRouter.self) private var mainRouter
    @Environment(ThemeBackground.self) private var themeBackground
    
    var body: some View {
        ZStack {
            // Background color
            themeBackground.backgroundView()
            
            VStack(spacing: 0) {
                // Custom large title
                HStack {
                    Text("DragonDex")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        mainRouter.presentSheet(.about)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(themeBackground.themeColor)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(dragonService.dragons) { dragon in
                            DragonCardView(dragon: dragon)
                                .onTapGesture {
                                    router.navigateToDetail(dragon)
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
        DragonListView()
            .environment(DragonRouter())
            .environment(DragonDataService())
            .environment(MainRouter())
            .environment(ThemeBackground(theme: DragonTheme.inferno))
    }
}
