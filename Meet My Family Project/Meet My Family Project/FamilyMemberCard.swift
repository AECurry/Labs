//
//  FamilyMemberCard.swift
//  Meet My Family Project
//
//  Created by AnnElaine on 10/9/25.
//

import SwiftUI

struct FamilyMemberCard: View {
    let member: FamilyMember
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Gradient Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color("rlNavy"), Color("rlCrimson")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 16) {
                    // Profile Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 100, height: 100)
                        
                        if let assetName = member.assetPhotoName {
                            Image(assetName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Text content with checkmark
                    VStack(spacing: 6) {
                        Text(member.name.isEmpty ? "Add Name" : member.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(member.relationship.isEmpty ? "Add Relationship" : member.relationship)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(1)
                        
                        // Checkmark indicator
                        if member.hasBeenViewed {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.green, Color.white)
                            }
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        }
                    }
                }
                .padding(20)
            }
            .frame(width: 160, height: 220)
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: Color("rlNavy").opacity(0.3), radius: 8, x: 0, y: 4)
    }
}
