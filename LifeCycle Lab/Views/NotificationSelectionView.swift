//
//  NotificationSelectionView.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct NotificationBannerView: View {
    @Binding var isShowingSimulation: Bool
    @Binding var events: [String]
    
    var body: some View {
        Button {
            // Simulate tapping a notification that takes you to another app
            events.append("Notification tapped - app backgrounding - \(Date().formatted(date: .omitted, time: .standard))")
            isShowingSimulation = true
        } label: {
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.white)
                
                VStack(alignment: .leading) {
                    Text("Lifecycle Lab")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Tap to simulate app backgrounding")
                        .font(.caption)
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Text("Now")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
