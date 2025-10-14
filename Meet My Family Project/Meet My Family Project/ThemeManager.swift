//
//  ThemeManager.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI
import Observation

@Observable
class ThemeManager {
    var currentTheme: AppTheme = .poloClub
    
    enum AppTheme {
        case poloClub, safari, rugby
    }
    
    var primaryColor: Color {
        switch currentTheme {
        case .poloClub: return Color("rlNavy")
        case .safari: return Color.brown
        case .rugby: return Color.red
        }
    }
    
    var backgroundColor: Color {
        switch currentTheme {
        case .poloClub: return Color("rlCream")
        case .safari: return Color.orange.opacity(0.1)
        case .rugby: return Color.white
        }
    }
}
