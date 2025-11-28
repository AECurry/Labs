//
//  DogControlsSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct DogControlsSection: View {
    // Only the DATA this view needs to display
    let isLoading: Bool
    let canSave: Bool
    
    // Only the ACTIONS this view can trigger
    let onNewImageTapped: () -> Void
    let onSaveToListTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button("New Image") {
                onNewImageTapped()
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isLoading)
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
            )
            
            Button("Save to List") {
                onSaveToListTapped()
            }
            .buttonStyle(SecondaryButtonStyle())
            .disabled(!canSave || isLoading)
        }
    }
}

