//
//  FakeAppView.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct FakeAppView: View {
    @Binding var isPresented: Bool
    @Binding var events: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            // Top section with back button and title
            VStack(spacing: 0) {
                // Back button in top leading corner
                HStack {
                    Button {
                        events.append("Returning to Lifecycle Lab - app foregrounding - \(Date().formatted(date: .omitted, time: .standard))")
                        isPresented = false
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Lifecycle Lab")
                                .font(.system(size: 14))
                        }
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Title
                Text("App Backgrounded")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
            
            // Fake iOS Status Bar
            HStack {
                Text("9:41")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "wifi")
                    Image(systemName: "battery.100")
                }
                .font(.system(size: 14))
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Spacer()
            
            // Fake App Icons (simulating iOS home screen)
            VStack(spacing: 25) {
                HStack(spacing: 25) {
                    FakeAppIcon(iconName: "message.fill", color: .green, label: "Messages")
                    FakeAppIcon(iconName: "safari.fill", color: .blue, label: "Safari")
                    FakeAppIcon(iconName: "camera.fill", color: .gray, label: "Camera")
                    FakeAppIcon(iconName: "photos.fill", color: .purple, label: "Photos")
                }
                
                HStack(spacing: 25) {
                    FakeAppIcon(iconName: "map.fill", color: .green, label: "Maps")
                    FakeAppIcon(iconName: "clock.fill", color: .black, label: "Clock")
                    FakeAppIcon(iconName: "gamecontroller.fill", color: .orange, label: "Games")
                    FakeAppIcon(iconName: "app.gift.fill", color: .red, label: "App Store")
                }
            }
            
            Spacer()
            
            // Dock with more apps
            HStack(spacing: 25) {
                FakeAppIcon(iconName: "phone.fill", color: .green, label: "Phone")
                FakeAppIcon(iconName: "mail.fill", color: .blue, label: "Mail")
                FakeAppIcon(iconName: "safari.fill", color: .blue, label: "Safari")
                FakeAppIcon(iconName: "music.note", color: .pink, label: "Music")
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .onAppear {
            events.append("App backgrounded - moved to other app - \(Date().formatted(date: .omitted, time: .standard))")
        }
    }
}

struct FakeAppIcon: View {
    let iconName: String
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 60, height: 60)
                
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.primary)
        }
    }
}
