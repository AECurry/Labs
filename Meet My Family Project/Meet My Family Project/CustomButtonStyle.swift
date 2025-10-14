//
//  CustomButtonStyle.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI

struct RLButtonStyle: ButtonStyle {
    var style: RLButtonType = .primary
    var size: RLButtonSize = .medium
    
    enum RLButtonType {
        case primary, secondary, outline
    }
    
    enum RLButtonSize {
        case small, medium, large
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return Color("rlNavy")
        case .secondary: return Color("rlCrimson")
        case .outline: return .clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .secondary: return .white
        case .outline: return Color("rlNavy")
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline: return Color("rlNavy")
        default: return .clear
        }
    }
    
    private var padding: EdgeInsets {
        switch size {
        case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        case .medium: return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        case .large: return EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
        }
    }
    
    private var font: Font {
        switch size {
        case .small: return .caption.weight(.semibold)
        case .medium: return .body.weight(.semibold)
        case .large: return .title3.weight(.semibold)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(font)
            .foregroundColor(textColor)
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: style == .outline ? 2 : 0)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
