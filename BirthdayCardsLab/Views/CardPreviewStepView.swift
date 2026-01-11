//
//  CardPreviewStepView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct CardPreviewStepView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    @State private var showShareSheet = false
    @State private var showSavedAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress dots at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            .padding(.top, 10)
            .padding(.bottom, 64) // Space between stepper and card
            
            // Card Preview
            CardTemplateView(
                card: coordinator.card,
                currentStep: coordinator.currentStep.rawValue,
                isPreviewMode: true
            )
            .scaleEffect(0.85)
            .frame(width: 306, height: 428)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.bottom, 64) // Space between card and buttons
            
            // Compact Horizontal Action Buttons
            HStack(spacing: 20) {
                // Share Button
                Button(action: {
                    showShareSheet = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 24))
                            .frame(height: 30)
                        
                        Text("Share")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
                
                // Save Button
                Button(action: {
                    coordinator.saveCard()
                    showSavedAlert = true
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "tray.and.arrow.down")
                            .font(.system(size: 24))
                            .frame(height: 30)
                        
                        Text("Save")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
                
                // Create Another Button
                Button(action: {
                    coordinator.resetToFirstStep()
                    coordinator.card = BirthdayCard()
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 24))
                            .frame(height: 30)
                        
                        Text("New")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30) // Space between buttons and back button
            
            // Back Button at bottom
            HStack {
                Button(action: { coordinator.navigateToPreviousStep() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .frame(minWidth: 100)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                // Empty spacer for balance
                Spacer()
                    .frame(minWidth: 100)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Preview Your Card")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [generateShareText()])
        }
        .alert("Card Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your birthday card has been saved to your collection.")
        }
    }
    
    private func generateShareText() -> String {
        let title = coordinator.card.cardTitle.isEmpty ? "Birthday Party!" : coordinator.card.cardTitle
        let date = coordinator.card.date.formatted(date: .long, time: .omitted)
        let description = coordinator.card.partyDescription.isEmpty ? "Join us for celebration!" : coordinator.card.partyDescription
        
        return """
        🎉 \(title) 🎉
        
        Date: \(date)
        
        \(description)
        
        Created with Birthday Cards Lab
        """
    }
}

// Share Sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    let coordinator = CardCreationCoordinator()
    coordinator.card = BirthdayCard(
        cardTitle: "Wendy's 40th Birthday!",
        partyDescription: "We are celebrating Wendy's 40th birthday with food, games, and fun!",
        date: Date().addingTimeInterval(86400 * 7),
        themeColor: ThemeColor(color: .purple)
    )
    
    return CardPreviewStepView()
        .environment(coordinator)
}
