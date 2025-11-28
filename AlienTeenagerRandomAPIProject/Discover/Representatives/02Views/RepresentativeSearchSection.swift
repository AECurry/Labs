//
//  RepresentativeSearchSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

struct RepresentativeSearchSection: View {
    @Binding var zipCode: String
    let isLoading: Bool
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            
            // ========== SEARCH TEXT FIELD ==========
            HStack(spacing: 24) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Enter Zip Code", text: $zipCode)
                    .keyboardType(.numberPad)
                    .textContentType(.postalCode)
                
                if !zipCode.isEmpty {
                    Button {
                        zipCode = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(width: 250, height: 48)
            .background(Color.white)
            .cornerRadius(16)
            
            // ========== SEARCH BUTTON ==========
            Button("Search") {
                onSearch()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(zipCode.count != 5 || isLoading)
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
            )
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        CustomGradientBkg2()
        RepresentativeSearchSection(
            zipCode: .constant("84043"),
            isLoading: false,
            onSearch: { print("Search tapped") }
        )
    }
}
