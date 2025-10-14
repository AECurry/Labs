//
//  ContentView.swift
//  Buttons Lab
//
//  Created by AnnElaine on 9/29/25.
//

import SwiftUI

// MARK: - Custom Button Style
struct GlowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.purple : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: .blue.opacity(configuration.isPressed ? 0.2 : 0.8),
                    radius: configuration.isPressed ? 2 : 10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - Content View
struct ContentView: View {
    @State private var toggledDisabled = false
    @State private var message = "Press a button!"
    @State private var textChangeStep = 0
    @State private var pressEffectToggled = false

    var body: some View {
        ScrollView {                                        // allows vertical scrolling on small screens
            VStack(spacing: 28) {                           // overall vertical stack
               
                // -- two columns container --
                HStack(alignment: .top, spacing: 48) {
                    
                    // ===== Column 1 =====
                    VStack(spacing: 22) {
                        // 1
                        Button("Red Button") {
                            message = "Red Button tapped"
                        }
                        .frame(width: 120, height: 42)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        // 2
                        Button("Barbie Pink") {
                            message = "Pink Circle tapped"
                        }
                        .frame(width: 80, height: 80)
                        .background(Color(red: 0.96, green: 0.12, blue: 0.53)) // famous "Barbie" pink
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        
                        // 3
                        Button("Yellow Big Text") {
                            message = "Yellow Big Text tapped"
                        }
                        .font(.title3)
                        .frame(width: 140, height: 44)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        // 4
                        Button("Purple Shadow") {
                            message = "Purple Shadow tapped"
                        }
                        .frame(width: 150, height: 42)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                        
                        // 5 (custom style)
                        Button("Custom Glow") {
                            message = "Custom Glow tapped"
                        }
                        .buttonStyle(GlowButtonStyle())
                        .frame(width: 150, height: 42)
                    }
                    // If you still want to nudge only column 1 toward the center, uncomment and adjust:
                    // .padding(.leading, 40)
                    
                    
                    // ===== Column 2 =====
                    VStack(spacing: 22) {
                        // 6 — Changing Text (cycles case0 → case1 → case2)
                        Button("Changing Text") {
                            // use current case first, then advance
                            switch textChangeStep {
                            case 0:
                                message = "Press this button again to see what happens!"
                            case 1:
                                message = "Congratulations! You changed the screen text again!"
                            case 2:
                                message = "Hey, third time's the charm, right!"
                            default:
                                break
                            }
                            textChangeStep = (textChangeStep + 1) % 3
                        }
                        .frame(width: 180, height: 42)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(72)
                        
                        // 7 — Can be disabled (disabled state controlled by the Toggle)
                        Button("Toggle Disabled") {
                            message = "Toggle Disabled tapped"
                        }
                        .frame(width: 150, height: 42)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(toggledDisabled)
                        
                        // toggle that controls whether Button 7 is disabled
                        Toggle("Disable Button 7", isOn: $toggledDisabled)
                            .frame(width: 200)
                        
                        // 8 — Gradient button that toggles message (press effect)
                        Button("Press Effect") {
                            pressEffectToggled.toggle()
                            message = pressEffectToggled ? "Press Effect ON" : "Press Effect OFF"
                        }
                        .frame(width: 200, height: 48)
                        .background(
                            LinearGradient(colors: [Color.purple, Color.blue],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(24)
                        
                        // 9 — Icon button (image instead of text)
                        Button(action: {
                            message = "Icon tapped"
                        }) {
                            Image(systemName: "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .foregroundColor(Color(red: 0.6, green: 0.2, blue: 0.7))
                        }
                        
                        // 10 — Border only style
                        Button("Border Only") {
                            message = "Border tapped"
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red, lineWidth: 4)
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)  // keep the two-column group centered
                .padding(.horizontal, 24)                        // even leading / trailing breathing room
                
                
                // Visible message shown beneath columns
                Text(message)
                    .padding(.top, 8)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
