//
//  SymbolsCelebrationView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/9/25.
//

import SwiftUI

struct SymbolsCelebrationView: View {
    @Bindable var viewModel: CountdownViewModel
    var namespace: Namespace.ID
    
    private let celebrationSymbols = ["sparkles", "balloon.fill", "party.popper.fill", "confetti", "fireworks"]
    
    var body: some View {
        ZStack {
            ForEach(0..<5) { index in
                let symbolName = celebrationSymbols[index]
                let position = symbolPosition(for: index, radius: 100)
                
                Image(systemName: symbolName)
                    .font(.system(size: symbolSize(for: index)))
                    .foregroundStyle(symbolGradient(for: index))
                    .symbolEffect(.bounce, value: viewModel.currentNumber)
                    .scaleEffect(symbolScale(for: index))
                    .position(position)
                    .opacity(symbolOpacity(for: index))
                    .matchedGeometryEffect(
                        id: "symbol_\(index)",
                        in: namespace,
                        properties: .position,
                        anchor: .center,
                        isSource: false
                    )
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7)
                        .delay(Double(index) * 0.1),
                        value: viewModel.currentNumber
                    )
            }
        }
        .frame(width: 250, height: 250)
    }
    
    // Helper Methods
    
    private func symbolPosition(for index: Int, radius: CGFloat) -> CGPoint {
        let angle = 2 * .pi / 5 * CGFloat(index)
        let x = radius * cos(angle) + 125
        let y = radius * sin(angle) + 125
        
        guard let currentNumber = viewModel.currentNumber else {
            return CGPoint(x: x, y: y)
        }
        
        // Symbols move inward as countdown progresses
        let progress = CGFloat(3 - currentNumber) / 3.0
        let adjustedRadius = radius * (0.4 + progress * 0.6)
        return CGPoint(
            x: adjustedRadius * cos(angle) + 125,
            y: adjustedRadius * sin(angle) + 125
        )
    }
    
    private func symbolSize(for index: Int) -> CGFloat {
        guard let currentNumber = viewModel.currentNumber else { return 35 }
        return index == (3 - currentNumber) ? 50 : 35
    }
    
    private func symbolGradient(for index: Int) -> LinearGradient {
        let gradients: [LinearGradient] = [
            LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom),
            LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom),
            LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom),
            LinearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottom),
            LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom)
        ]
        return gradients[index % gradients.count]
    }
    
    private func symbolScale(for index: Int) -> CGFloat {
        guard let currentNumber = viewModel.currentNumber else { return 1.0 }
        return index == (3 - currentNumber) ? 1.2 : 1.0
    }
    
    private func symbolOpacity(for index: Int) -> Double {
        guard let currentNumber = viewModel.currentNumber else { return 0 }
        let progress = Double(3 - currentNumber) / 3.0
        return index == (3 - currentNumber) ? 1.0 : 0.3 + (0.7 * progress)
    }
}

