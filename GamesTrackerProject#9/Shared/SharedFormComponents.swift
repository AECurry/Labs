//
//  SharedFormComponents.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.fnWhite)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.fnGray1)
            }
        }
    }
}

// MARK: - Section Style Modifier

struct SectionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.fnBlack.opacity(0.3))
            .cornerRadius(12)
    }
}

extension View {
    func sectionStyle() -> some View {
        modifier(SectionStyle())
    }
}

// MARK: - Save Button

struct SaveButton: View {
    let title: String
    let isEnabled: Bool
    let isSaving: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if isSaving {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .fnWhite))
                    .scaleEffect(1.2)
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.fnWhite)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isEnabled ? Color.fnBlue : Color.fnGray1)
        .cornerRadius(12)
        .disabled(!isEnabled || isSaving)
        .padding(.top, 20)
    }
}

// MARK: - Previews

#Preview("Section Header") {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        VStack {
            SectionHeader(title: "Personal Information")
            SectionHeader(title: "Contact Information", subtitle: "Optional")
        }
        .padding()
    }
}

#Preview("Save Button") {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            // Fixed: Added all required parameters
            SaveButton(
                title: "Save",
                isEnabled: true,
                isSaving: false,
                action: {}
            )
            SaveButton(
                title: "Save",
                isEnabled: false,
                isSaving: false,
                action: {}
            )
            SaveButton(
                title: "Saving...",
                isEnabled: true,
                isSaving: true,
                action: {}
            )
        }
        .padding()
    }
}

