//
//  DescriptionInputStepView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct DescriptionInputStepView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    
    // Text styling options
    @State private var selectedFontSize: FontSize = .medium
    @State private var selectedTextColor: TextColor = .black
    
    enum FontSize: String, CaseIterable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case extraLarge = "Extra Large"
        
        var size: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 18
            case .extraLarge: return 20
            }
        }
    }
    
    enum TextColor: String, CaseIterable {
        case black = "Black"
        case darkGray = "Dark Gray"
        case white = "White"
        case blue = "Blue"
        case red = "Red"
        case green = "Green"
        
        var color: Color {
            switch self {
            case .black: return .black
            case .darkGray: return .gray
            case .white: return .white
            case .blue: return .blue
            case .red: return .red
            case .green: return .green
            }
        }
    }
    
    var body: some View {
        @Bindable var coordinator = coordinator
        
        VStack(spacing: 24) {
            // Progress dots at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            .padding(.top, 10)
            
            // Character count at top
            HStack {
                Spacer()
                Text("\(coordinator.card.partyDescription.count)/200")
                    .font(.caption)
                    .foregroundColor(coordinator.card.partyDescription.count > 200 ? .red : .gray)
                    .padding(.horizontal)
                    .padding(.top, 5)
            }
            
            // Text editor with current styling
            TextEditor(text: $coordinator.card.partyDescription)
                .font(.system(size: selectedFontSize.size))
                .foregroundColor(selectedTextColor.color)
                .frame(minHeight: 150)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.top, 0)
            
            // Placeholder when empty
            if coordinator.card.partyDescription.isEmpty {
                Text("Enter details like location, activities, dress code, RSVP etc...")
                    .foregroundColor(.gray.opacity(0.6))
                    .font(.caption)
                    .padding(.horizontal, 24)
                    .multilineTextAlignment(.center)
                    
            }
            
            // Text styling pickers
            VStack(spacing: 20) {
                // Font size picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Size")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Picker("Font Size", selection: $selectedFontSize) {
                        ForEach(FontSize.allCases, id: \.self) { size in
                            Text(size.rawValue).tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 4)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Text color picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Color")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(TextColor.allCases, id: \.self) { textColor in
                                VStack(spacing: 8) {
                                    // Color circle with gray background
                                    ZStack {
                                        Circle()
                                            .fill(Color(.systemGray6))
                                            .frame(width: 48, height: 48)
                                        
                                        Circle()
                                            .fill(textColor.color)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedTextColor == textColor ? Color.blue : Color.clear, lineWidth: 3)
                                            )
                                    }
                                    .onTapGesture {
                                        selectedTextColor = textColor
                                    }
                                    
                                    // Color name
                                    Text(textColor.rawValue)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Navigation buttons at bottom
            StepNavigationView()
                .padding(.bottom)
        }
        .navigationTitle("Describe your party")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Load existing font size
            if coordinator.card.descriptionFontSize == 14 {
                selectedFontSize = .small
            } else if coordinator.card.descriptionFontSize == 16 {
                selectedFontSize = .medium
            } else if coordinator.card.descriptionFontSize == 18 {
                selectedFontSize = .large
            } else if coordinator.card.descriptionFontSize == 20 {
                selectedFontSize = .extraLarge
            }
            
            // Load existing text color
            let currentColor = coordinator.card.descriptionTextColor
            // Simple color matching
            if currentColor == .black {
                selectedTextColor = .black
            } else if currentColor == .gray {
                selectedTextColor = .darkGray
            } else if currentColor == .white {
                selectedTextColor = .white
            } else if currentColor == .blue {
                selectedTextColor = .blue
            } else if currentColor == .red {
                selectedTextColor = .red
            } else if currentColor == .green {
                selectedTextColor = .green
            }
        }
        .onChange(of: selectedFontSize) { oldValue, newValue in
            coordinator.card.descriptionFontSize = Double(newValue.size)
        }
        .onChange(of: selectedTextColor) { oldValue, newValue in
            coordinator.card.updateTextColor(newValue.color)
        }
    }
}

#Preview {
    let coordinator = CardCreationCoordinator()
    coordinator.card.partyDescription = "Join us for pizza, games, and celebration!"
    
    return DescriptionInputStepView()
        .environment(coordinator)
}
