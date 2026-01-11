//
//  CardTemplateView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct CardTemplateView: View {
    let card: BirthdayCard
    let currentStep: Int
    let isPreviewMode: Bool
    
    private let cardWidth: CGFloat = 360
    private let cardHeight: CGFloat = 504
    
    // Determine if card is "empty" (just starting)
    private var isEmptyCard: Bool {
        card.cardTitle.isEmpty &&
        card.partyDescription.isEmpty &&
        card.imageData == nil &&
        card.themeColor == nil
    }
    
    init(card: BirthdayCard, currentStep: Int = 1, isPreviewMode: Bool = false) {
        self.card = card
        self.currentStep = currentStep
        self.isPreviewMode = isPreviewMode
    }
    
    var body: some View {
        ZStack {
            // Background color - grayscale if empty/placeholder, color if chosen
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(borderColor, lineWidth: 1)
                )
            
            VStack(spacing: 24) {
                // Title Section
                VStack {
                    if card.cardTitle.isEmpty && !isPreviewMode {
                        Text("YOUR PARTY TITLE")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(placeholderTextColor)
                            .opacity(currentStep >= 1 ? 1 : 1.5)
                    } else {
                        Text(card.cardTitle.isEmpty ? "Birthday Party!" : card.cardTitle)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(textColorForBackground)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .frame(height: cardHeight * 0.2)
                
                // Image & Date Section
                VStack(spacing: 16) {
                    // Image Area
                    if let imageData = card.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: cardWidth * 0.8, height: cardHeight * 0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(borderColor, lineWidth: 2)
                            )
                            .grayscale(isEmptyCard ? 1.0 : 0.0) // Grayscale only if empty
                    } else if !isPreviewMode {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(placeholderBackgroundColor)
                                .frame(width: cardWidth * 0.8, height: cardHeight * 0.4)
                            
                            VStack {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(placeholderTextColor)
                                Text("Add a Party Photo")
                                    .font(.caption)
                                    .foregroundColor(placeholderTextColor)
                            }
                            .opacity(currentStep >= 3 ? 1 : 1.5)
                        }
                    }
                    
                    // Date Area
                    VStack {
                        if !isPreviewMode && currentStep < 4 {
                            Text("PARTY DATE")
                                .font(.headline)
                                .foregroundColor(placeholderTextColor)
                                .opacity(1.5)
                        } else {
                            Text("PARTY DATE")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(textColorForBackground)
                            
                            // Format date to show date and time on separate lines
                            VStack(spacing: 2) {
                                Text(card.date.formatted(date: .long, time: .omitted))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(textColorForBackground)
                                
                                Text("at " + card.date.formatted(date: .omitted, time: .shortened))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(textColorForBackground)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                        }
                    }
                }
                .frame(height: cardHeight * 0.6)
                
                // Description Section
                VStack {
                    if card.partyDescription.isEmpty && !isPreviewMode {
                        Text("Describe your amazing party here...")
                            .font(.body)
                            .foregroundColor(placeholderTextColor)
                            .multilineTextAlignment(.center)
                            .opacity(currentStep >= 2 ? 1 : 1.5)
                    } else {
                        Text(card.partyDescription.isEmpty ? "Join us for a celebration!" : card.partyDescription)
                            .font(.system(size: CGFloat(card.descriptionFontSize)))
                            .foregroundColor(card.descriptionTextColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .padding(.horizontal)
                    }
                }
                .frame(height: cardHeight * 0.2)
            }
            .padding(20)
        }
        .frame(width: cardWidth, height: cardHeight)
        .grayscale(isEmptyCard ? 1.0 : 0.0) // Grayscale only if card is empty
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColor: Color {
        if let themeColor = card.themeColor?.color {
            return themeColor
        } else {
            return Color(white: 0.96) // Light gray for empty state
        }
    }
    
    private var borderColor: Color {
        isEmptyCard ? Color.gray.opacity(0.3) : Color.white.opacity(0.5)
    }
    
    private var placeholderTextColor: Color {
        isEmptyCard ? .gray.opacity(0.6) : .white.opacity(0.8)
    }
    
    private var placeholderBackgroundColor: Color {
        isEmptyCard ? Color.gray.opacity(0.1) : Color.white.opacity(0.2)
    }
    
    private var textColorForBackground: Color {
        if isEmptyCard {
            return .black // Black for grayscale card
        } else {
            // Calculate contrast for colored background
            let backgroundColor = card.themeColor?.color ?? Color.blue
            let uiColor = UIColor(backgroundColor)
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            let luminance = 0.299 * r + 0.587 * g + 0.114 * b
            return luminance > 0.5 ? .black : .white
        }
    }
}

struct CardTemplatePreview: View {
    let card: BirthdayCard
    let currentStep: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Card Preview")
                .font(.caption)
                .foregroundColor(.secondary)
            
            CardTemplateView(card: card, currentStep: currentStep)
                .scaleEffect(0.85)
                .frame(width: 306, height: 428)
        }
    }
}

struct ProgressDotsView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Step \(currentStep) of \(totalSteps)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(1...totalSteps, id: \.self) { step in
                    Circle()
                        .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: step == currentStep ? 12 : 8,
                               height: step == currentStep ? 12 : 8)
                        .animation(.spring(response: 0.3), value: currentStep)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // Empty card (grayscale)
        CardTemplateView(
            card: BirthdayCard(),
            currentStep: 1,
            isPreviewMode: false
        )
        .padding()
        
        // Partially filled card (some color)
        CardTemplateView(
            card: BirthdayCard(
                cardTitle: "John's 30th",
                partyDescription: "Join us for celebration!",
                date: Date(),
                themeColor: ThemeColor(color: .blue)
            ),
            currentStep: 4,
            isPreviewMode: false
        )
        .padding()
        
        // Complete card (full color)
        CardTemplateView(
            card: BirthdayCard(
                cardTitle: "Wendy's Birthday Bash!",
                partyDescription: "Let's celebrate Wendy's birthday with food, games, and fun!",
                date: Date().addingTimeInterval(86400 * 7),
                themeColor: ThemeColor(color: .purple),
                imageData: nil
            ),
            currentStep: 6,
            isPreviewMode: true
        )
        .padding()
    }
}
