//
//  ResultsPopupView.swift
//  ParkersRandomSelectorApp
//
//  Created by AnnElaine on 2/23/26.
//

// DUMB CHILD VIEW - Black popup showing selected names
import SwiftUI

struct ResultsPopupView: View {
    let selectedUsers: [User] // Names to display
    let onClose: () -> Void   // Close callback
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                // Header with title and close button
                HStack {
                    Text("Selected")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 8)
                
                Divider()
                    .background(Color.white.opacity(0.3))
                    .padding(.horizontal, 24)
                
                // Selected names - vertically centered
                VStack(alignment: .center, spacing: 14) {
                    ForEach(selectedUsers) { user in
                        Text(user.name)
                            .font(.title3)
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.top, 4)
                
                Spacer(minLength: 0) // Pushes content up, leaves space at bottom
            }
            .frame(width: 340, height: 480) // Fixed size card
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .position(x: geometry.size.width / 2, y: geometry.size.height / 3) // Centered horizontally, positioned up
        }
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.3)
            .ignoresSafeArea()
        
        ResultsPopupView(
            selectedUsers: [
                User(name: "Michael Sterling"),
                User(name: "Bella Standhope"),
                User(name: "Teddy Salinski"),
                User(name: "Hope Powell")
            ],
            onClose: {}
        )
    }
}
