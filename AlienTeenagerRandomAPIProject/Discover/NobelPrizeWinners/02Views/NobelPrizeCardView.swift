//
//  NobelPrizeCardView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import SwiftUI

struct NobelPrizeCardView: View {
    let prize: NobelPrize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with year and category
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(prize.categoryFullName ?? prize.category.capitalized)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // Category icon
                Image(systemName: categoryIcon)
                    .font(.title2)
                    .foregroundColor(categoryColor)
            }
            
            // Laureate information
            if let laureates = prize.laureates, !laureates.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Laureates")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(laureates) { laureate in
                                VStack(spacing: 8) {
                                    // Use the improved image view
                                    LaureateImageView(laureate: laureate)
                                        .frame(width: 80, height: 80)
                                    
                                    // Format name with first name on top, last name on bottom
                                    VStack(spacing: 2) {
                                        Text(getFirstName(from: laureate.fullName?.en ?? "Unknown"))
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(1)
                                        
                                        Text(getLastName(from: laureate.fullName?.en ?? "Unknown"))
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 80)
                                }
                            }
                        }
                    }
                    
                    // Motivation text
                    if let motivation = getCombinedMotivation(laureates: laureates) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Motivation")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(motivation)
                                .font(.body)
                                .italic()
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 8)
                    }
                }
            } else {
                // DEFAULT MESSAGE for no laureates
                VStack(spacing: 12) {
                    Image(systemName: "person.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No award given this year")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
            
            // Date Awarded - Only show if there are laureates
            if let laureates = prize.laureates, !laureates.isEmpty,
               let dateAwarded = prize.dateAwarded {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text(formatDate(dateAwarded))
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Helper function to extract first name only
    private func getFirstName(from fullName: String) -> String {
        let components = fullName.split(separator: " ")
        guard let firstName = components.first else { return fullName }
        return String(firstName)
    }
    
    // Helper function to extract last name only (no middle names)
    private func getLastName(from fullName: String) -> String {
        let components = fullName.split(separator: " ")
        guard components.count > 1 else { return "" }
        
        // Take only the last component as the last name
        if let lastName = components.last {
            return String(lastName)
        }
        
        return ""
    }
    
    private func getCombinedMotivation(laureates: [Laureate]) -> String? {
        // Get the first non-nil motivation
        for laureate in laureates {
            if let motivation = laureate.motivation?.en, !motivation.isEmpty {
                return motivation
            }
        }
        return nil
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
    
    // Helper computed properties for category styling
    private var categoryIcon: String {
        switch prize.category.lowercased() {
        case "physics": return "atom"
        case "chemistry": return "testtube.2"
        case "medicine", "physiology or medicine": return "heart.text.square"
        case "literature": return "book"
        case "peace": return "leaf"
        case "economics": return "dollarsign.circle"
        default: return "trophy"
        }
    }
    
    private var categoryColor: Color {
        switch prize.category.lowercased() {
        case "physics": return .blue
        case "chemistry": return .green
        case "medicine", "physiology or medicine": return .pink
        case "literature": return .orange
        case "peace": return .red
        case "economics": return .purple
        default: return .gray
        }
    }
}

struct LaureateImageView: View {
    let laureate: Laureate
    @State private var imageError: Bool = false
    @State private var currentImageURL: URL?
    
    var body: some View {
        Group {
            if let imageURL = currentImageURL, !imageError {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .scaleEffect(0.8)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .onAppear {
                                imageError = true
                            }
                    @unknown default:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
        .onAppear {
            setupImageURL()
        }
    }
    
    private func setupImageURL() {
        // Try multiple image sources in order of preference
        
        // 1. First try the Wikipedia slug URL
        if let wikiURL = laureate.wikipedia?.imageURL {
            currentImageURL = wikiURL
        }
        // 2. Fallback to API portrait endpoint
        else {
            let apiPortraitURL = URL(string: "https://api.nobelprize.org/2/laureate/\(laureate.id)/portrait")
            currentImageURL = apiPortraitURL
        }
    }
}
