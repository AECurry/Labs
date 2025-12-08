//
//  RootView.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var mainRouter = MainRouter()
    @State private var themeBackground = ThemeBackground()
    @State private var dragonService: DragonDataService?
    @State private var riderService: RiderDataService?
    
    var body: some View {
        Group {
            if let dragonSvc = dragonService, let riderSvc = riderService {
                TabView(selection: $mainRouter.selectedTab) {
                    DragonsTab(dragonService: dragonSvc)
                        .tabItem { Label("Dragons", systemImage: "flame.fill") }
                        .tag(MainRouter.Tab.dragons)
                    
                    RidersTab(riderService: riderSvc)
                        .tabItem { Label("Riders", systemImage: "person.fill") }
                        .tag(MainRouter.Tab.riders)
                }
                .tint(themeBackground.themeColor)
                .sheet(isPresented: Binding(
                    get: { mainRouter.presentedSheet == .about },
                    set: { if !$0 { mainRouter.dismissSheet() } }
                )) {
                    SettingsView()
                }
            } else {
                ProgressView("Initializing DragonDex...")
            }
        }
        .environment(mainRouter)
        .environment(themeBackground)
        .onAppear {
            dragonService = DragonDataService(modelContext: modelContext)
            riderService = RiderDataService(modelContext: modelContext)
        }
    }
}

// MARK: - Dragon Tab
struct DragonsTab: View {
    let dragonService: DragonDataService
    @State private var dragonRouter = DragonRouter()
    
    var body: some View {
        NavigationStack(path: $dragonRouter.navigationPath) {
            DragonListView()
                .navigationDestination(for: DragonRouter.Route.self) { route in
                    switch route {
                    case .detail(let dragon):
                        DragonDetailView(dragon: dragon)
                    case .powers(let dragon):
                        PowersListView(dragon: dragon)
                    default:
                        EmptyView()
                    }
                }
        }
        .environment(dragonService)
        .environment(dragonRouter)
    }
}

// MARK: - Riders Tab (FIXED)
struct RidersTab: View {
    let riderService: RiderDataService
    @State private var riderRouter: RiderRouter
    
    init(riderService: RiderDataService) {
        self.riderService = riderService
        _riderRouter = State(initialValue: RiderRouter(riderService: riderService))
    }
    
    var body: some View {
        NavigationStack(path: $riderRouter.navigationPath) {
            RiderListView()
                .navigationDestination(for: RiderRouter.Route.self) { route in
                    riderRouter.view(for: route)
                }
        }
        .environment(riderService)
        .environment(riderRouter)
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Dragon.self, Power.self, Rider.self])
}
