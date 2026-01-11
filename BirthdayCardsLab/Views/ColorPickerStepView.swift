//
//  ColorPickerStepView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct ColorPickerStepView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    @State private var selectedColor: Color = .blue
    
    var body: some View {
        VStack(spacing: 36) {
            // Progress dots at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            .padding(.top, 10)
            
            // Instructions
            Text("Choose card color")
                .font(.title2)
                .fontWeight(.medium)
            
            // Color picker
            VStack(alignment: .leading, spacing: 15) {
                Text("Background Color")
                    .font(.headline)
                
                ColorPicker("Select a color", selection: $selectedColor)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                // Color preview
                HStack {
                    Text("Selected Color:")
                        .font(.subheadline)
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.primary, lineWidth: 1)
                        )
                    Text(selectedColor.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Preset colors
            VStack(alignment: .leading, spacing: 10) {
                Text("Quick Picks")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(presetColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Tips
            VStack(alignment: .leading, spacing: 8) {
                Text("🎨 Tips:")
                    .font(.headline)
                Text("• Choose colors that match your party theme")
                Text("• Light colors work best for readability")
                Text("• Consider the season or occasion")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            // Navigation buttons at bottom
            StepNavigationView()
        }
        .padding()
        .navigationTitle("Choose Color")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Load existing color
            if let themeColor = coordinator.card.themeColor {
                selectedColor = themeColor.color
            }
        }
        .onChange(of: selectedColor) { oldValue, newValue in
            coordinator.card.themeColor = ThemeColor(color: newValue)
        }
    }
    
    private let presetColors: [Color] = [
        .blue, .green, .purple, .orange, .pink,
        .yellow, .red, .teal, .indigo, .mint
    ]
}

#Preview {
    let coordinator = CardCreationCoordinator()
    
    return ColorPickerStepView()
        .environment(coordinator)
}
