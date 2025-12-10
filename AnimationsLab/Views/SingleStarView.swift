//
//  SingleStarView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/9/25.
//

/// CHILD: Renders one star symbol with matched geometry animation
/// MATCHED GEOMETRY: Uses namespace for smooth position transitions
/// SOLID: Single Responsibility - displays one animated star
import SwiftUI

struct SingleStarView: View {
    let index: Int
    let state: StarState
    let containerSize: CGSize
    let namespace: Namespace.ID
    
    // Configuration per star
    private let symbols = ["star.fill", "star.fill", "star.fill", "star.fill"]
    private let colors: [[Color]] = [
        [.blue, .purple],
        [.green, .blue],
        [.orange, .red],
        [.yellow, .orange]
    ]
    
    var body: some View {
        Image(systemName: symbols[index])
            .font(.system(size: fontSize))
            .foregroundStyle(LinearGradient(
                colors: colors[index],
                startPoint: .top,
                endPoint: .bottom
            ))
            .opacity(opacity)
            .scaleEffect(scale)
            .position(position)
            .matchedGeometryEffect(
                id: "symbol_\(index)",
                in: namespace,
                properties: .frame,
                anchor: .center,
                isSource: isSource
            )
            .animation(animation, value: state)
    }
    
    // Computed Properties
    
    private var position: CGPoint {
        switch state {
        case .inCorner:
            return startPosition
        case .movingToCenter, .inCenter, .gone:  // All these states use endPosition
            return endPosition
        }
    }
    
    private var startPosition: CGPoint {
        guard containerSize != .zero else { return .zero }
        
        let horizontalSpacing = containerSize.width / 5
        let verticalPosition = containerSize.height * 0.8
        
        switch index {
        case 0: return CGPoint(x: horizontalSpacing, y: verticalPosition)
        case 1: return CGPoint(x: horizontalSpacing * 2, y: verticalPosition)
        case 2: return CGPoint(x: horizontalSpacing * 3, y: verticalPosition)
        case 3: return CGPoint(x: horizontalSpacing * 4, y: verticalPosition)
        default: return CGPoint(x: containerSize.width / 2, y: containerSize.height / 2)
        }
    }
    
    private var endPosition: CGPoint {
        CGPoint(x: containerSize.width / 2, y: containerSize.height / 3)
    }
    
    private var opacity: Double {
        switch state {
        case .inCorner, .movingToCenter, .inCenter:
            return 1.0
        case .gone:
            return 0.0
        }
    }
    
    private var scale: CGFloat {
        switch state {
        case .inCorner:
            return 1.0
        case .movingToCenter:
            return 1.2  // Grow while moving
        case .inCenter:
            return 1.0  // Back to normal size
        case .gone:
            return 1.0  // Keep normal size while fading
        }
    }
    
    private var fontSize: CGFloat {
        (state == .inCenter || state == .movingToCenter) ? 40 : 30
    }
    
    private var isSource: Bool {
        (state == .movingToCenter || state == .inCenter) && index == 0
    }
    
    private var animation: Animation {
        switch state {
        case .movingToCenter:
            return .spring(response: 0.6, dampingFraction: 0.7)
        case .gone:
            return .easeOut(duration: 0.3)
        default:
            return .default
        }
    }
}
