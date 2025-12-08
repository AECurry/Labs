//
//  DragonRouter.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI
import Observation

@Observable
final class DragonRouter {
    enum Route: Hashable {
        case list
        case detail(Dragon)
        case powers(Dragon)
    }
    
    var navigationPath = NavigationPath()
    var presentedSheet: SheetType?
    
    enum SheetType: Hashable, Identifiable {
        case addDragon
        case editDragon(Dragon)
        
        var id: Self { self }
    }
    
    func navigate(to route: Route) {
        navigationPath.append(route)
        print("🐉 DragonRouter navigating to: \(route)")
    }
    
    func navigateToDetail(_ dragon: Dragon) {
        navigate(to: .detail(dragon))
    }
    
    func navigateToPowers(_ dragon: Dragon) {
        navigate(to: .powers(dragon))
    }
    
    func presentSheet(_ sheet: SheetType) {
        presentedSheet = sheet
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
}
