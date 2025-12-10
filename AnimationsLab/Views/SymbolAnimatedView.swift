//
//  SymbolAnimatedView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/9/25.
//

import SwiftUI

struct SymbolAnimatedView: View {
    let symbolName: String
    let startCorner: Corner
    let isActive: Bool
    let shouldDisappear: Bool
    
    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }
    
    var body: some View {
        GeometryReader { geometry in
            Image(systemName: symbolName)
                .font(.system(size: 60))
                .foregroundColor(.white)
                .opacity(shouldDisappear ? 0 : 1)
                .scaleEffect(shouldDisappear ? 0.5 : 1.0)
                .frame(width: 60, height: 60)
                .position(
                    isActive ? centerPosition(size: geometry.size) : cornerPosition(size: geometry.size)
                )
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.7),
                    value: isActive
                )
                .animation(
                    .easeIn(duration: 0.3),
                    value: shouldDisappear
                )
        }
    }
    
    private func cornerPosition(size: CGSize) -> CGPoint {
        switch startCorner {
        case .topLeft:
            return CGPoint(x: 60, y: 120)
        case .topRight:
            return CGPoint(x: size.width - 60, y: 120)
        case .bottomLeft:
            return CGPoint(x: 60, y: size.height - 120)
        case .bottomRight:
            return CGPoint(x: size.width - 60, y: size.height - 120)
        }
    }
    
    private func centerPosition(size: CGSize) -> CGPoint {
        return CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    }
}

