//
//  CustomNavigationBar.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI

struct RLCustomNavigationBar: View {
    let title: String
    let showBackButton: Bool
    let actionButton: AnyView?
    var onBack: (() -> Void)? = nil
    
    init(title: String, showBackButton: Bool = false, actionButton: AnyView? = nil, onBack: (() -> Void)? = nil) {
        self.title = title
        self.showBackButton = showBackButton
        self.actionButton = actionButton
        self.onBack = onBack
    }
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(.rlCream)
                .frame(height: 60)
                .shadow(color: .rlNavy.opacity(0.1), radius: 2, x: 0, y: 2)
            
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.rlNavy)
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 44, height: 44)
                    }
                } else {
                    Spacer().frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.rlNavy)
                
                Spacer()
                
                if let actionButton = actionButton {
                    actionButton
                } else {
                    Spacer().frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 60)
    }
}
