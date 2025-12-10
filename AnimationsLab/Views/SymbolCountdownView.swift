//
//  SymbolCountdownView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/9/25.
//

/// CHILD: Displays background celebration symbols/stars
/// DEPENDENCY: Receives @Bindable viewModel from parent
/// SOLID: Single Responsibility - manages symbol animations in background
/// MATCHED GEOMETRY: Uses @Namespace for smooth symbol transitions
import SwiftUI

struct SymbolCountdownView: View {
    @Bindable var viewModel: CountdownViewModel
    @Namespace private var animationNamespace
    @State private var containerSize: CGSize = .zero
    @State private var starAnimation = StarAnimationView()
    
    var body: some View {
        ZStack {
            // Background is handled by parent MainAppView
            // This view only manages star animations
            
            VStack(spacing: 0) {
                Spacer()
                
                // Show stars only during countdown
                if viewModel.isCountdownActive && !viewModel.showGoText {
                    starContainerView()
                        .offset(y: 30)
                }
                
                Spacer()
                
                // Bottom content (restart button when done)
                bottomContentView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
       
        .onChange(of: viewModel.currentNumber) { oldNumber, newNumber in
            if let newNumber = newNumber {
                starAnimation.update(for: newNumber, showGoText: false)
            }
        }
        .onChange(of: viewModel.showGoText) { oldValue, newValue in
            if newValue {
                starAnimation.update(for: 0, showGoText: true)
            }
        }
    }
    
    // Subviews
    
    private func starContainerView() -> some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                SingleStarView(
                    index: index,
                    state: starAnimation.states[index],
                    containerSize: containerSize,
                    namespace: animationNamespace
                )
            }
        }
        .frame(width: 300, height: 200)
        .padding(.vertical, 20)
        .background(GeometryReader { proxy in
            Color.clear
                .onAppear { containerSize = proxy.size }
                .onChange(of: proxy.size) { oldSize, newSize in
                    containerSize = newSize
                }
        })
    }
    
    private func bottomContentView() -> some View {
        Group {
            if viewModel.shouldShowGetReady {
                Text("Get Ready...")
                    .font(.title3)
                    .foregroundColor(.orange)
                    .transition(.opacity)
                    .padding(.bottom, 40)
            } else if viewModel.showGoText {
                restartButtonView()
                    .padding(.bottom, 40)
            }
        }
    }
    
    private func restartButtonView() -> some View {
        Button(action: restartCountdown) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.clockwise")
                Text("Restart Countdown")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .shadow(color: .purple.opacity(0.5), radius: 10)
            )
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Helpers
    
    private func restartCountdown() {
        starAnimation.reset()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            viewModel.resetCountdown()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                viewModel.startCountdown()
            }
        }
    }
}

#Preview {
    SymbolCountdownView(viewModel: CountdownViewModel())
}
