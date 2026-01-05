import SwiftUI

struct TimeframeButton: View {
    let timeframe: RankingTimeframe
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(timeframe.rawValue)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .fnBlack : .fnWhite)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    Color.fnWhite : Color.fnGray3.opacity(0.3)
                )
                .cornerRadius(20)
        }
    }
}

struct ModeButton: View {
    let mode: RankingMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: mode.iconName)
                    .font(.caption)
                
                Text(mode.rawValue)
                    .font(.subheadline)
            }
            .fontWeight(.semibold)
            .foregroundColor(isSelected ? .fnWhite : .fnGray1)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(backgroundView)
            .cornerRadius(25)
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if isSelected {
            // Use ViewBuilder to return different view types
            LinearGradient(
                colors: gradientColors(for: mode),
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            Color.fnGray3.opacity(0.2)
        }
    }
    
    private func gradientColors(for mode: RankingMode) -> [Color] {
        switch mode {
        case .solo: return [.fnBlue, .fnPurple]
        case .duo: return [.fnGreen, .fnBlue]
        case .squad: return [.fnPurple, .fnRed] // Using fnRed instead of fnPink since you have it
        }
    }
}

// Alternative simpler version without gradients (more maintainable):
struct ModeButtonSimple: View {
    let mode: RankingMode
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: mode.iconName)
                    .font(.caption)
                
                Text(mode.rawValue)
                    .font(.subheadline)
            }
            .fontWeight(.semibold)
            .foregroundColor(isSelected ? .fnWhite : .fnGray1)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(backgroundColor)
            .cornerRadius(25)
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return modeBackgroundColor
        } else {
            return Color.fnGray3.opacity(0.2)
        }
    }
    
    private var modeBackgroundColor: Color {
        switch mode {
        case .solo: return .fnBlue
        case .duo: return .fnGreen
        case .squad: return .fnPurple
        }
    }
}

struct RankBadgeView: View {
    let rank: Int
    
    var body: some View {
        Text("\(rank)")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(rankColor)
            .frame(width: 30)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .fnGold
        case 2: return .fnSilver
        case 3: return .fnBronze
        default: return .fnGray1
        }
    }
}

struct RankingLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.fnWhite)
            
            Text("Loading rankings...")
                .font(.headline)
                .foregroundColor(.fnWhite)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
