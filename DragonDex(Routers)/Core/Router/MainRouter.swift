//
//  MainRouter.swift
//  DragonDex(Routers)
//
//  Created by [Your Name] on [Date]
//

import SwiftUI
import Observation

@Observable
final class MainRouter {
    var selectedTab: Tab = .dragons
    var presentedSheet: SheetType?  // This is what AboutView is trying to dismiss
    
    let dragonRouter = DragonRouter()
    let riderRouter: RiderRouter
    
    enum Tab {
        case dragons
        case riders
        case settings
    }
    
    enum SheetType: Hashable, Identifiable {
        case settings
        
        var id: Self { self }
    }
    
    init() {
            // Initialize with a mock or real service
            let riderService = RiderDataService()
            self.riderRouter = RiderRouter(riderService: riderService)
        }
        
        func switchToTab(_ tab: Tab) {
            selectedTab = tab
        }
        
        func presentSheet(_ sheet: SheetType) {
            presentedSheet = sheet
        }
        
        func dismissSheet() {
            presentedSheet = nil
        }
    }
