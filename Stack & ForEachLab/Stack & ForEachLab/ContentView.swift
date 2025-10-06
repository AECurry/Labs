import SwiftUI

// MARK: - HomeView (Top-to-Bottom Layout)
struct HomeView: View {
    
    let statsData = [
        StatItem(icon: "trophy.fill", number: "6", label: "My Rewards"),
        StatItem(icon: "magnifyingglass", number: "6/203", label: "Daily Points"),
        StatItem(icon: "checkmark.circle.fill", number: "0 days", label: "Daily Streak")
    ]
    
    let menuItems = [
        MenuItem(icon: "bell.fill", title: "Notifications"),
        MenuItem(icon: "star.fill", title: "Microsoft Rewards"),
        MenuItem(icon: "person.3.fill", title: "Community"),
        MenuItem(icon: "gearshape.fill", title: "Settings"),
        MenuItem(icon: "heart.fill", title: "Interests"),
        MenuItem(icon: "clock.fill", title: "History"),
        MenuItem(icon: "bookmark.fill", title: "Bookmarks & Saves")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // 🔹 1. Top Chevron Navigation
                HStack {
                    Button(action: { print("Back tapped") }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top, 24)
                
                // 🔹 2. Profile Section
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.08))
                        .frame(height: 100)
                    
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(20)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("John Mobbin")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .bold()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                            
                            Text("john.mobbin1@outlook.com")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.7))
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                // 🔹 3. Stats Section
                StatsCardView(statsData: statsData)
                    .padding(.vertical, 8)
                    .padding(.bottom, 24
                    )
                
                // 🔹 4. Menu Section
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(menuItems) { item in
                        HStack(spacing: 8) {
                            Image(systemName: item.icon)
                                .foregroundColor(.blue)
                            Text(item.title)
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 🔹 5. (Optional) Bottom Navigation could go here
            }
        }
    }
}

// MARK: - StatsCardView (Helper View)
struct StatsCardView: View {
    let statsData: [StatItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(statsData) { stat in
                VStack(spacing: 4) {
                    Image(systemName: stat.icon)
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text(stat.number)
                        .font(.title3)
                        .foregroundColor(.black)
                    Text(stat.label)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                if stat.id != statsData.last?.id {
                    Divider()
                        .background(Color.gray)
                }
            }
        }
        .padding(.vertical, 16)
        .frame(height: 124)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(radius: 2)
        )
        .padding(.horizontal)
    }
}

// MARK: - Models
struct StatItem: Identifiable {
    let id = UUID()
    let icon: String
    let number: String
    let label: String
}

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

// MARK: - Preview
struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
}
