//
//  CustomCardView.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI

struct RLCard<Content: View>: View {
    let content: Content
    var style: RLCardStyle = .elevated
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 16
    
    enum RLCardStyle {
        case elevated, outlined, filled, gradient
    }
    
    init(style: RLCardStyle = .elevated, cornerRadius: CGFloat = 20, padding: CGFloat = 16, @ViewBuilder content: () -> Content) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    private var backgroundColor: some View {
        Group {
            switch style {
            case .elevated, .outlined:
                Color(.systemBackground)
            case .filled:
                Color("rlCream")
            case .gradient:
                LinearGradient(
                    colors: [Color("rlCream"), Color("rlCream").opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outlined:
            return Color("rlNavy").opacity(0.2)
        default:
            return .clear
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .elevated:
            return Color("rlNavy").opacity(0.1)
        default:
            return .clear
        }
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(
                color: shadowColor,
                radius: style == .elevated ? 8 : 0,
                x: 0,
                y: style == .elevated ? 4 : 0
            )
    }
}
