//
//  ForgotPasswordButtonView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct ForgotPasswordButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Forgot Password?")
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}
