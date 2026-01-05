//
//  LoginButtonView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct LoginButtonView: View {
    let action: () -> Void
    let isDisabled: Bool
    
    var body: some View {
        Button(action: action) {
            Text("Login")
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isDisabled)
    }
}
