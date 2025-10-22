//
//  BackgroundSimulationView.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/21/25.
//

import SwiftUI

struct BackgroundSimulationView: View {
    let notificationType: String
    @Binding var isPresented: Bool
    @Binding var events: [String]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Header
            VStack(spacing: 15) {
                Image(systemName: getIconName())
                    .font(.system(size: 70))
                    .foregroundColor(getIconColor())
                
                Text(notificationType)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(getDescription())
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Return Button with arrow (like your original)
            Button {
                events.append("Returned from \(notificationType) simulation - \(Date().formatted(date: .omitted, time: .standard))")
                isPresented = false
            } label: {
                HStack {
                    Image(systemName: "arrow.left.circle.fill")
                    Text("Return to Lifecycle Lab")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            events.append("Simulating \(notificationType) - \(Date().formatted(date: .omitted, time: .standard))")
        }
    }
    
    private func getIconName() -> String {
        switch notificationType {
        case "App Backgrounded": return "lock.fill"
        case "App Foregrounded": return "lock.open.fill"
        case "Scene Phase Changes": return "circle.hexagongrid.circle.fill"
        default: return "bell.fill"
        }
    }
    
    private func getIconColor() -> Color {
        switch notificationType {
        case "App Backgrounded": return .red
        case "App Foregrounded": return .green
        case "Scene Phase Changes": return .orange
        default: return .blue
        }
    }
    
    private func getDescription() -> String {
        switch notificationType {
        case "App Backgrounded":
            return "The app has entered the background state"
        case "App Foregrounded":
            return "The app has become active again"
        case "Scene Phase Changes":
            return "Observing scene phase transitions"
        default:
            return "Lifecycle event simulation"
        }
    }
}
