//
//  PlayerProfileHeader.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/15/25.
//

import SwiftUI

struct PlayerProfileHeader: View {
    var onPhotoTap: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 12) {
            // Profile Image Placeholder
            ZStack {
                Circle()
                    .fill(Color.fnGray3)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.fnGray1)
                
                // Add Photo Button
                Circle()
                    .fill(Color.fnBlue)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.caption)
                            .foregroundColor(.fnWhite)
                    )
                    .offset(x: 35, y: 35)
            }
            .onTapGesture {
                onPhotoTap?()
            }
            
            Text("Tap to add photo")
                .font(.caption)
                .foregroundColor(.fnGray1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        PlayerProfileHeader()
    }
}

