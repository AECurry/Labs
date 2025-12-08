//
//  RiderRouter.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import Observation

@Observable
final class RiderRouter {
    enum Route: Hashable {
        case list
        case detail(Rider)
        case achievements(Rider)
        case dragons(Rider)  // This needs to match the case name in the switch
    }
    
    var navigationPath = NavigationPath()
    var presentedSheet: SheetType?
    
    // Add the RiderDataService dependency
    let riderService: RiderDataService
    
    init(riderService: RiderDataService) {
        self.riderService = riderService
    }
    
    func navigate(to route: Route) {
        navigationPath.append(route)
        print("🏇 RiderRouter navigating to: \(route)")
    }
    
    func navigateToDetail(_ rider: Rider) {
        navigate(to: .detail(rider))
    }
    
    func navigateToAchievements(_ rider: Rider) {
        navigate(to: .achievements(rider))
    }
    
    func navigateToDragons(_ rider: Rider) {
        navigate(to: .dragons(rider))
    }
    
    func presentSheet(_ sheet: SheetType) {
        presentedSheet = sheet
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    // View builder - FIXED VERSION:
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .list:
            RiderListView()
            
        case .detail(let rider):
            RiderDetailView(rider: rider)
            
        case .achievements(let rider):
            RiderAchievementsView(rider: rider)
            
        case .dragons(let rider):  // Changed from .dragonsTamed to .dragons
            RiderDragonsView(rider: rider)
        }
    }
}

// You might also need a SheetType enum:
extension RiderRouter {
    enum SheetType: Hashable, Identifiable {
        case addRider
        case editRider(Rider)
        
        var id: Self { self }
    }
}
