//
//  RepresentativeListCell.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

struct RepresentativeListCell: View {
    let representative: Representative
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name and Party
            HStack {
                Text(representative.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(representative.party)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(partyColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(partyColor.opacity(0.2))
                    .cornerRadius(6)
            }
            
            // Title/District
            Text(representative.displayTitle)
                .font(.subheadline)
                .foregroundColor(.darkGray1)
            
            // Contact Info
            HStack(spacing: 16) {
                // Phone
                if !representative.phone.isEmpty {
                    Label(representative.phone, systemImage: "phone.fill")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                
                // State
                Label(representative.state, systemImage: "mappin.circle.fill")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            // Office
            if !representative.office.isEmpty {
                Text(representative.office)
                    .font(.caption)
                    .foregroundColor(.darkGray1)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(Color.alabasterGray.opacity(0.8))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    // MARK: - Computed Properties
    private var partyColor: Color {
        switch representative.party.uppercased() {
        case "D":
            return .blue
        case "R":
            return .red
        default:
            return .darkGray1
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        CustomGradientBkg2()
        VStack(spacing: 12) {
            RepresentativeListCell(
                representative: Representative(
                    name: "John Smith",
                    party: "D",
                    state: "UT",
                    district: "3",
                    phone: "202-555-0123",
                    office: "123 Capitol Building",
                    link: "https://example.com"
                )
            )
            RepresentativeListCell(
                representative: Representative(
                    name: "Jane Doe",
                    party: "R",
                    state: "UT",
                    district: "Senate",
                    phone: "202-555-0456",
                    office: "456 Senate Building",
                    link: "https://example.com"
                )
            )
        }
        .padding()
    }
}

