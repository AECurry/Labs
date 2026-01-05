//
//  StatusMessageView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct StatusMessageView: View {
    let loginState: LoginState
    
    var body: some View {
        Group {
            switch loginState {
            case .idle:
                EmptyView()
                
            case .loading:
                HStack {
                    ProgressView()
                        .padding(.trailing, 8)
                    Text("Logging in...")
                        .foregroundColor(.gray)
                }
                .padding()
                
            case .success:
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Login successful!")
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
            case .error(let message):
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(message)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}
