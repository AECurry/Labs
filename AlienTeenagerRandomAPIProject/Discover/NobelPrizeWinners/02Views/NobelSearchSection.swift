//
//  NobelSearchSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/24/25.
//

import SwiftUI

struct NobelSearchSection: View {
    @Binding var yearInput: String
    @Binding var categoryInput: String
    let categories: [String]  // This should now contain all individual categories
    let isLoading: Bool
    let onSearch: () -> Void
    let onClearSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 30) { // Increased spacing
            // Year Input
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                TextField("Enter Year", text: $yearInput)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        hideKeyboard()
                    }
            }
            
            // Category Picker - Now shows all individual categories
            HStack {
                Image(systemName: "trophy")
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                Picker("Category", selection: $categoryInput) {
                    Text("All Categories").tag("")
                    ForEach(categories, id: \.self) { category in
                        Text(category.capitalized).tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .tint(.white) // White color for the picker
            }
            
            // Buttons container
            ZStack {
                HStack(spacing: 16) {
                    // Spacer to push search button to center when clear is hidden
                    Spacer()
                    
                    // Search Button - always centered when alone
                    Button {
                        hideKeyboard()
                        onSearch()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Search")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled((yearInput.isEmpty && categoryInput.isEmpty) || isLoading)
                    
                    // Clear Button - appears next to search when active
                    if !yearInput.isEmpty || !categoryInput.isEmpty {
                        Button {
                            hideKeyboard()
                            onClearSearch()
                        } label: {
                            Text("Clear")
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    // Spacer to balance the layout
                    Spacer()
                }
            }
            .frame(height: 50) // Fixed height to prevent layout shifts
        }
        .padding()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
