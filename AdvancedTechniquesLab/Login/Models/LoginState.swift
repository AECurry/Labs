//
//  LoginState.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import Foundation

enum LoginState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}
