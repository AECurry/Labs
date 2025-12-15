//
//  SwipeToDeleteCard.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/12/25.
//

import SwiftUI

struct SwipeToDeleteCard<Content: View>: View {
    let match: TournamentMatch
    let onDelete: () -> Void
    let content: Content
    
    @State private var offset: CGFloat = 0
    @State private var isDeleting = false
    
    // Constants
    private let deleteThreshold: CGFloat = 80
    private let deleteButtonWidth: CGFloat = 100
    
    init(
        match: TournamentMatch,
        onDelete: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.match = match
        self.onDelete = onDelete
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Red delete background
            if offset < 0 {
                deleteBackground
            }
            
            // Main content
            content
                .offset(x: offset)
                .gesture(swipeGesture)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Delete Background
    private var deleteBackground: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "trash.fill")
                    .font(.title2)
                
                Text("Delete")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(width: deleteButtonWidth)
            .opacity(deleteOpacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
    
    // MARK: - Computed Properties
    private var canDelete: Bool {
        !match.isLive
    }
    
    private var deleteOpacity: Double {
        guard canDelete else { return 0 }
        let progress = min(abs(offset) / deleteThreshold, 1.0)
        return Double(progress)
    }
    
    // MARK: - Swipe Gesture
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { gesture in
                guard canDelete && !isDeleting else { return }
                
                let horizontalAmount = abs(gesture.translation.width)
                let verticalAmount = abs(gesture.translation.height)
                
                // Only activate swipe if primarily horizontal movement
                if horizontalAmount > verticalAmount {
                    // Only allow left swipe (negative offset)
                    if gesture.translation.width < 0 {
                        offset = gesture.translation.width
                    }
                }
            }
            .onEnded { gesture in
                guard canDelete && !isDeleting else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = 0
                    }
                    return
                }
                
                let horizontalAmount = abs(gesture.translation.width)
                let verticalAmount = abs(gesture.translation.height)
                
                // Only process as swipe if movement was primarily horizontal
                if horizontalAmount > verticalAmount {
                    // If swiped past threshold, delete
                    if offset < -deleteThreshold {
                        performDelete()
                    } else {
                        // Otherwise, snap back
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            offset = 0
                        }
                    }
                } else {
                    // Was a vertical scroll, reset position
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        offset = 0
                    }
                }
            }
    }
    
    // MARK: - Delete Action
    private func performDelete() {
        isDeleting = true
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Animate card off screen
        withAnimation(.easeInOut(duration: 0.3)) {
            offset = -500
        }
        
        // Call delete closure after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDelete()
        }
    }
}

// MARK: - Preview
#Preview("Swipeable Card") {
    VStack(spacing: 20) {
        // Non-live match (can delete)
        SwipeToDeleteCard(
            match: TournamentMatch(
                team1Name: "Team Alpha",
                team1Score: 15,
                team1Color: .blue,
                team2Name: "Team Bravo",
                team2Score: 12,
                team2Color: .red,
                timeRemaining: "0:00:00",
                isLive: false,
                matchNumber: 1,
                gameMode: .battleRoyale
            ),
            onDelete: {
                print("✅ Card deleted!")
            }
        ) {
            TournamentCard(
                match: TournamentMatch(
                    team1Name: "Team Alpha",
                    team1Score: 15,
                    team1Color: .blue,
                    team2Name: "Team Bravo",
                    team2Score: 12,
                    team2Color: .red,
                    timeRemaining: "0:00:00",
                    isLive: false,
                    matchNumber: 1,
                    gameMode: .battleRoyale
                )
            )
        }
        .padding()
        
        // Live match (cannot delete)
        SwipeToDeleteCard(
            match: TournamentMatch(
                team1Name: "Live Match",
                team1Score: 10,
                team1Color: .orange,
                team2Name: "Active Game",
                team2Score: 8,
                team2Color: .purple,
                timeRemaining: "0:05:30",
                isLive: true,
                matchNumber: 2,
                gameMode: .battleRoyale
            ),
            onDelete: {
                print("Should not delete live match")
            }
        ) {
            TournamentCard(
                match: TournamentMatch(
                    team1Name: "Live Match",
                    team1Score: 10,
                    team1Color: .orange,
                    team2Name: "Active Game",
                    team2Score: 8,
                    team2Color: .purple,
                    timeRemaining: "0:05:30",
                    isLive: true,
                    matchNumber: 2,
                    gameMode: .battleRoyale
                )
            )
        }
        .padding()
    }
}
