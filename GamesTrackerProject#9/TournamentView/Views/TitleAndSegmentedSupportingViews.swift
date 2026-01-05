//
//  TitleAndSegmentedSupportingViews.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/19/25.
//

import SwiftUI

// MARK: - Supporting Views
struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.fnGray2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EmptyStateView: View {
    let status: MatchStatus
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconForStatus)
                .font(.largeTitle)
                .foregroundColor(.fnGray2)
            
            Text(messageForStatus)
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            Text(subtitleForStatus)
                .font(.caption)
                .foregroundColor(.fnGray2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.fnBlack.opacity(0.3))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var iconForStatus: String {
        switch status {
        case .all: return "trophy"
        case .live: return "livephoto"
        case .upcoming: return "clock"
        case .completed: return "checkmark.circle"
        }
    }
    
    private var messageForStatus: String {
        switch status {
        case .all: return "No matches yet"
        case .live: return "No live matches"
        case .upcoming: return "No upcoming matches"
        case .completed: return "No completed matches"
        }
    }
    
    private var subtitleForStatus: String {
        switch status {
        case .all: return "Tap the + button to create your first game!"
        case .live: return "Check back later for live action"
        case .upcoming: return "Upcoming matches will appear here"
        case .completed: return "Completed matches will appear here"
        }
    }
}

// MARK: - Preview for supporting views
#Preview("Error View") {
    ZStack {
        AnimatedGridBackground()
        ErrorView(message: "Failed to load matches. Please check your connection.")
    }
}

#Preview("Empty State - All") {
    ZStack {
        AnimatedGridBackground()
        EmptyStateView(status: .all)
    }
}

#Preview("Empty State - Live") {
    ZStack {
        AnimatedGridBackground()
        EmptyStateView(status: .live)
    }
}

