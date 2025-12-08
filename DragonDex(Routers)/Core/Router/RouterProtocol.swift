//
//  RouterProtocol.swift
//  DragonDex(Routers)
//
//  Created by AnnElaine on 12/4/25.
//

import SwiftUI

protocol Router: ObservableObject {
    associatedtype Route: Hashable
    var navigationPath: NavigationPath { get set }
    
    func navigate(to route: Route)
}

extension Router {
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
    
    func printNavigationState() {
        print("\(Self.self) - Navigation Depth: \(navigationPath.count)")
    }
}
